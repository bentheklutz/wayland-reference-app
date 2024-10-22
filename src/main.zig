//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const wayland = @import("wayland");
const wl = wayland.client.wl;
const xdg = wayland.client.xdg;
const xkb = @import("xkbcommon");

const pipewire = @import("pipewire-0.3_2.zig");

const Context = struct {
    running: bool,
    shm: ?*wl.Shm,
    compositor: ?*wl.Compositor,
    wm_base: ?*xdg.WmBase,
    seat: ?*wl.Seat,
    keyboard: ?*wl.Keyboard,
    pointer: ?*wl.Pointer,
    xkb_state: ?*xkb.State,
};

pub fn main() !void {
    const display = try wl.Display.connect(null);
    const registry = try display.getRegistry();
    pipewire.init(@ptrCast(&std.os.argv.len), std.os.argv.ptr);

    const mainloop = pipewire.MainLoop.new(null) orelse return;

    std.log.debug("Pipewire compiled with {s}\nPipewire linked with {s}\nMainLoop is {}", .{ pipewire.get_headers_version(), pipewire.get_library_version(), mainloop });

    var context = Context{
        .running = true,
        .shm = null,
        .compositor = null,
        .wm_base = null,
        .seat = null,
        .keyboard = null,
        .pointer = null,
        .xkb_state = null,
    };

    registry.setListener(*Context, registryListener, &context);
    if (display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    const shm = context.shm orelse return error.NoWlShm;
    const compositor = context.compositor orelse return error.NoWlCompositor;
    const wm_base = context.wm_base orelse return error.NoXdgWmBase;
    const seat = context.seat orelse return error.NoSeat;

    wm_base.setListener(*Context, xdgWmBaseListener, &context);

    seat.setListener(*Context, seatListener, &context);
    if (display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    const buffer = blk: {
        const width = 128;
        const height = 128;
        const stride = width * 4;
        const size = stride * height;

        const fd = try std.posix.memfd_create("app", 0);
        try std.posix.ftruncate(fd, size);
        const data = try std.posix.mmap(
            null,
            size,
            std.posix.PROT.READ | std.posix.PROT.WRITE,
            .{ .TYPE = .SHARED },
            fd,
            0,
        );
        @memcpy(data, @embedFile("cat.bgra"));

        const pool = try shm.createPool(fd, size);
        defer pool.destroy();

        break :blk try pool.createBuffer(0, width, height, stride, wl.Shm.Format.argb8888);
    };
    defer buffer.destroy();

    const surface = try compositor.createSurface();
    defer surface.destroy();
    const xdg_surface = try wm_base.getXdgSurface(surface);
    defer xdg_surface.destroy();
    const xdg_toplevel = try xdg_surface.getToplevel();
    defer xdg_toplevel.destroy();

    xdg_surface.setListener(*wl.Surface, xdgSurfaceListener, surface);
    xdg_toplevel.setListener(*Context, xdgToplevelListener, &context);

    surface.commit();
    if (display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    surface.attach(buffer, 0, 0);
    surface.commit();

    while (context.running) {
        if (display.dispatch() != .SUCCESS) return error.DispatchFailed;
    }
}

fn xdgWmBaseListener(xdg_wm_base: *xdg.WmBase, event: xdg.WmBase.Event, context: *Context) void {
    _ = context;
    switch (event) {
        .ping => |p| {
            xdg_wm_base.pong(p.serial);
        },
    }
}

fn registryListener(registry: *wl.Registry, event: wl.Registry.Event, context: *Context) void {
    switch (event) {
        .global => |global| {
            if (std.mem.orderZ(u8, global.interface, wl.Compositor.getInterface().name) == .eq) {
                context.compositor = registry.bind(global.name, wl.Compositor, 1) catch return;
            } else if (std.mem.orderZ(u8, global.interface, wl.Shm.getInterface().name) == .eq) {
                context.shm = registry.bind(global.name, wl.Shm, 1) catch return;
            } else if (std.mem.orderZ(u8, global.interface, xdg.WmBase.getInterface().name) == .eq) {
                context.wm_base = registry.bind(global.name, xdg.WmBase, 1) catch return;
            } else if (std.mem.orderZ(u8, global.interface, wl.Seat.getInterface().name) == .eq) {
                context.seat = registry.bind(global.name, wl.Seat, 1) catch return;
            }
        },
        .global_remove => {},
    }
}

fn keyboardListener(keyboard: *wl.Keyboard, event: wl.Keyboard.Event, context: *Context) void {
    _ = keyboard;
    switch (event) {
        .keymap => |km| {
            defer std.posix.close(km.fd);
            // TODO(Benjamin): This needs to map the fd from the event and read the keymap from it
            if (km.format != .xkb_v1) {
                std.log.err("Invalid keymap format: {s}\n", .{@tagName(km.format)});
                return;
            }
            const keymap = std.posix.mmap(null, km.size, std.posix.PROT.READ, .{ .TYPE = .PRIVATE }, km.fd, 0) catch |err| {
                std.log.err("Failed to mmap keymap fd: {s}", .{@errorName(err)});
                return;
            };
            defer std.posix.munmap(keymap);

            const xkb_context = xkb.Context.new(.no_flags) orelse return;
            const xkb_keymap = xkb.Keymap.newFromBuffer(xkb_context, keymap.ptr, keymap.len - 1, .text_v1, .no_flags) orelse {
                std.log.err("Failed to parse xkb keymap", .{});
                return;
            };
            defer xkb_keymap.unref();
            const state = xkb.State.new(xkb_keymap) orelse {
                std.log.err("Failed to create xkb state", .{});
                return;
            };
            defer state.unref();
            context.xkb_state = state.ref();
        },
        .enter => {},
        .leave => {},
        .key => |k| {
            const xs = context.xkb_state orelse return;

            const keycode = k.key + 8;
            const keysym = xs.keyGetOneSym(keycode);
            if (keysym == .NoSymbol) return;

            switch (@intFromEnum(keysym)) {
                xkb.Keysym.Return,
                xkb.Keysym.KP_Enter,
                => {},
                xkb.Keysym.Escape => {},
                xkb.Keysym.u => {},
                xkb.Keysym.BackSpace => {},
                xkb.Keysym.q => {
                    context.running = false;
                },
                else => {},
            }
        },
        .modifiers => |m| {
            if (context.xkb_state) |xs| {
                _ = xs.updateMask(m.mods_depressed, m.mods_latched, m.mods_locked, 0, 0, m.group);
            }
        },
    }
}

fn pointerListener(pointer: *wl.Pointer, event: wl.Pointer.Event, context: *Context) void {
    _ = pointer;
    _ = context;
    switch (event) {
        .enter => {
            std.debug.print("The pointer has entered the area\n", .{});
        },
        .leave => {
            std.debug.print("The pointer has left the area\n", .{});
        },
        .button => |btn| {
            std.debug.print("The pointer has pressed a button {}\n", .{btn.button});
        },
        .axis => |a| {
            std.debug.print("The pointer has scrolled {}\n", .{a.axis});
        },
        .motion => |m| {
            std.debug.print("The pointer has moved: ({}, {})\n", .{ m.surface_x, m.surface_y });
        },
    }
}

fn seatListener(seat: *wl.Seat, event: wl.Seat.Event, context: *Context) void {
    switch (event) {
        .capabilities => |cap| {
            if (cap.capabilities.pointer) {
                context.pointer = seat.getPointer() catch return;
                const pointer = context.pointer.?;
                pointer.setListener(*Context, pointerListener, context);
            }
            if (cap.capabilities.keyboard) {
                context.keyboard = seat.getKeyboard() catch return;
                const keyboard = context.keyboard.?;
                keyboard.setListener(*Context, keyboardListener, context);
            }
        },
    }
}

fn xdgSurfaceListener(xdg_surface: *xdg.Surface, event: xdg.Surface.Event, surface: *wl.Surface) void {
    switch (event) {
        .configure => |configure| {
            xdg_surface.ackConfigure(configure.serial);
            surface.commit();
        },
    }
}

fn xdgToplevelListener(_: *xdg.Toplevel, event: xdg.Toplevel.Event, context: *Context) void {
    switch (event) {
        .configure => {},
        .close => context.running = false,
    }
}
