//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const wayland = @import("wayland");
const wl = wayland.client.wl;
const xdg = wayland.client.xdg;
const xkb = @import("xkbcommon");

// const pipewire = @import("pipewire-0.3_2.zig");

const Context = struct {
    running: bool,
    shm: ?*wl.Shm,
    compositor: ?*wl.Compositor,
    wm_base: ?*xdg.WmBase,
    seat: ?*wl.Seat,
    keyboard: ?*wl.Keyboard,
    key_repeat_delay: ?i32,
    key_repeat_rate: ?i32,
    pointer: ?*wl.Pointer,
    xkb_state: ?*xkb.State,
    surface_ctx: SurfaceContext,
};

const SurfaceContext = struct {
    surface: ?*wl.Surface,
    buffer: ?*wl.Buffer,
    display_data: ?[]u8,
    xdg_surface: ?*xdg.Surface,
    xdg_toplevel: ?*xdg.Toplevel,
};

const width = 640;
const height = 640;
const bytes_per_pixel = 4;
const stride = width * bytes_per_pixel;

var player = struct {
    x: usize,
    y: usize,
}{
    .x = width / 2,
    .y = height / 2,
};

const color_background = Color(u8){
    .red = 0x00,
    .green = 0x48,
    .blue = 0x64,
    .alpha = 0xFF,
};
const color_player =
    Color(u8){
    .red = 0xDD,
    .green = 33,
    .blue = 0x64,
    .alpha = 0xFF,
};

fn render(buf: []u8, bg: Color(u8), p: Color(u8)) void {
    for (0..height) |y| {
        for (0..width) |x| {
            const idx = bytes_per_pixel * (y * height + x);
            buf[idx + 0] = bg.blue;
            buf[idx + 1] = bg.green;
            buf[idx + 2] = bg.red;
            buf[idx + 3] = bg.alpha;
        }
    }

    const player_size = 30;

    for (0..player_size) |y| {
        for (0..player_size) |x| {
            const pos_x = player.x + x - player_size / 2;
            const pos_y = player.y + y - player_size / 2;
            if (pos_x < 0 or pos_x > width or pos_y < 0 or pos_y > height) {
                continue;
            }

            const idx = bytes_per_pixel * (pos_y * height + pos_x);
            buf[idx + 0] = p.blue;
            buf[idx + 1] = p.green;
            buf[idx + 2] = p.red;
            buf[idx + 3] = p.alpha;
        }
    }
}

pub fn main() !void {
    const display = try wl.Display.connect(null);
    const registry = try display.getRegistry();
    // pipewire.init(@ptrCast(&std.os.argv.len), std.os.argv.ptr);

    // const mainloop = pipewire.MainLoop.new(null) orelse return;

    // std.log.debug("Pipewire compiled with {s}\nPipewire linked with {s}\nMainLoop is {}", .{ pipewire.get_headers_version(), pipewire.get_library_version(), mainloop });

    var context = Context{
        .running = true,
        .shm = null,
        .compositor = null,
        .wm_base = null,
        .seat = null,
        .keyboard = null,
        .key_repeat_delay = null,
        .key_repeat_rate = null,
        .pointer = null,
        .xkb_state = null,
        .surface_ctx = .{
            .surface = null,
            .buffer = null,
            .display_data = null,
            .xdg_surface = null,
            .xdg_toplevel = null,
        },
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
        // cat.bgra no longer works because the size is different
        // than that of the buffer
        // @memcpy(data, @embedFile("cat.bgra"));
        // @memset(data, 0xFF);
        //  128 pixels tall
        //  128 pixels wide
        // *  4 bytes/pixel
        // 121856 total bytes
        context.surface_ctx.display_data = data;

        render(
            data,
            Color(u8){
                .red = 0x00,
                .green = 0x48,
                .blue = 0x64,
                .alpha = 0xFF,
            },
            Color(u8){
                .red = 0xDD,
                .green = 33,
                .blue = 0x64,
                .alpha = 0xFF,
            },
        );

        const pool = try shm.createPool(fd, size);
        defer pool.destroy();

        break :blk try pool.createBuffer(0, width, height, stride, wl.Shm.Format.argb8888);
    };
    context.surface_ctx.buffer = buffer;

    buffer.setListener(*SurfaceContext, bufferListener, &context.surface_ctx);

    const surface = try compositor.createSurface();
    context.surface_ctx.surface = surface;
    defer surface.destroy();
    const xdg_surface = try wm_base.getXdgSurface(surface);
    context.surface_ctx.xdg_surface = xdg_surface;
    defer xdg_surface.destroy();
    const xdg_toplevel = try xdg_surface.getToplevel();
    context.surface_ctx.xdg_toplevel = xdg_toplevel;
    defer xdg_toplevel.destroy();

    xdg_surface.setListener(*SurfaceContext, xdgSurfaceListener, &context.surface_ctx);
    xdg_toplevel.setListener(*Context, xdgToplevelListener, &context);

    xdg_toplevel.setTitle("Reference Wayland Application");
    xdg_toplevel.setAppId("Ben Test");

    surface.commit();
    if (display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    surface.attach(buffer, 0, 0);
    surface.commit();

    while (context.running) {
        if (display.dispatch() != .SUCCESS) return error.DispatchFailed;

        surface.damage(0, 0, width, height);
    }
}

fn bufferListener(buffer: *wl.Buffer, event: wl.Buffer.Event, context: *SurfaceContext) void {
    _ = context;
    switch (event) {
        .release => {
            std.log.debug("Gotta release the buffer now", .{});
            buffer.destroy();
        },
    }
}

fn surfaceListener(surface: *wl.Surface, event: wl.Surface.Event, context: *SurfaceContext) void {
    _ = surface;
    _ = context;
    switch (event) {
        .enter => {},
        .leave => {},
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
                xkb.Keysym.W, xkb.Keysym.w => {
                    player.y += 1;
                },
                xkb.Keysym.A,
                xkb.Keysym.a,
                => {
                    player.x -= 1;
                },
                xkb.Keysym.S,
                xkb.Keysym.s,
                => {
                    player.y -= 1;
                },
                xkb.Keysym.D,
                xkb.Keysym.d,
                => {
                    player.x += 1;
                },
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
        .repeat_info => |ri| {
            context.*.key_repeat_delay = ri.delay;
            context.*.key_repeat_rate = ri.rate;
            std.debug.print("Keys will repeat after {d}ms at a rate of {d}/s", .{ ri.delay, ri.rate });
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
        .axis_source => |as| {
            std.debug.print("Axis source event {s}", .{@tagName(as.axis_source)});
        },
        .axis_discrete => |ad| {
            std.debug.print("Axis discrete event: {s} - {d}", .{ @tagName(ad.axis), ad.discrete });
        },
        .axis_stop => |as| {
            std.debug.print("Axis stop: {s}, {}", .{ @tagName(as.axis), as.time });
        },
        .frame => {
            std.debug.print("Pointer frame marker", .{});
        },
    }
}

fn Color(comptime T: type) type {
    switch (T) {
        f32, f64, u32, i32, u8, i8 => {
            return struct {
                red: T,
                green: T,
                blue: T,
                alpha: T,
            };
        },
        else => @compileError("Color only supports component types of 32/64 bit float and 8/32 bit int"),
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
        .name => |n| {
            std.log.debug("Hi, my name is {s}", .{n.name});
        },
    }
}

fn xdgSurfaceListener(xdg_surface: *xdg.Surface, event: xdg.Surface.Event, context: *SurfaceContext) void {
    switch (event) {
        .configure => |configure| {
            std.log.debug("CONGIURE", .{});
            xdg_surface.ackConfigure(configure.serial);
            if (context.surface) |surface| {
                // Shouldn't get here without a display buffer I believe
                render(context.display_data.?, color_background, color_player);
                surface.commit();
            }
        },
    }
}

fn xdgToplevelListener(_: *xdg.Toplevel, event: xdg.Toplevel.Event, context: *Context) void {
    switch (event) {
        .configure => {},
        .close => context.running = false,
    }
}
