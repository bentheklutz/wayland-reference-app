//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const wayland = @import("wayland");
const wl = wayland.client.wl;
const xdg = wayland.client.xdg;
const xkb = @import("xkbcommon");
const input_event_codes = @cImport(@cInclude("linux/input-event-codes.h"));

// const pipewire = @import("pipewire-0.3_2.zig");

const Context = struct {
    running: bool,
    last_frame_time: u32,
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

const width = 1280;
const height = 720;
const bytes_per_pixel = 4;
const stride = width * bytes_per_pixel;

const grid_rows = 10;
const grid_cols = 10;

/// Coordinates and velocities in grid space
var player = struct {
    x: i32,
    y: i32,
    dx: i32,
    dy: i32,
}{
    .x = width / 2,
    .y = height / 2,
    .dx = 0.0,
    .dy = 0.0,
};

const player_size = 30;

const Color = struct {
    red: u8,
    green: u8,
    blue: u8,
    alpha: u8,
};

const color_background = Color{ .red = 0x00, .green = 0x48, .blue = 0x64, .alpha = 0xFF };
const color_player = Color{ .red = 0xDD, .green = 33, .blue = 0x64, .alpha = 0xFF };

fn drawRectangle(buf: []u8, color: Color, _x: i32, _y: i32, _width: u32, _height: u32) void {
    const xu: usize = @intCast(_x);
    const yu: usize = @intCast(_y);
    for (0.._height) |y| {
        for (0.._width) |x| {
            const pos_x = xu + x - _width / 2;
            const pos_y = yu + y - _height / 2;
            if (pos_x > width or pos_y > height) {
                continue;
            }

            const idx = bytes_per_pixel * (pos_y * width + pos_x);
            buf[idx + 0] = color.blue;
            buf[idx + 1] = color.green;
            buf[idx + 2] = color.red;
            buf[idx + 3] = color.alpha;
        }
    }
}

fn render(buf: []u8, bg: Color, p: Color) void {
    // Background
    drawRectangle(buf, bg, width / 2, height / 2, width, height);

    // Grid outline for whatever reason
    for (1..grid_cols) |i| {
        const x: i32 = @intCast(width / grid_cols * i);
        drawRectangle(buf, .{ .red = 0x88, .green = 0x88, .blue = 0xDD, .alpha = 0xFF }, x, height / 2, 1, height);
    }
    for (1..grid_rows) |j| {
        const y: i32 = @intCast(height / grid_rows * j);
        drawRectangle(buf, .{ .red = 0x88, .green = 0x88, .blue = 0xDD, .alpha = 0xFF }, width / 2, y, width, 1);
    }
    // User-controlled "player" (WASD)
    drawRectangle(buf, p, player.x, player.y, player_size, player_size);
}

pub fn main() !void {
    const display = try wl.Display.connect(null);
    const registry = try display.getRegistry();
    // pipewire.init(@ptrCast(&std.os.argv.len), std.os.argv.ptr);

    // const mainloop = pipewire.MainLoop.new(null) orelse return;

    // std.log.debug("Pipewire compiled with {s}\nPipewire linked with {s}\nMainLoop is {}", .{ pipewire.get_headers_version(), pipewire.get_library_version(), mainloop });

    var context = Context{
        .running = true,
        .last_frame_time = 0,
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

        render(data, color_background, color_player);

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

    const frame_callback = try surface.frame();
    frame_callback.setListener(*Context, surfaceFrameListener, &context);

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

        player.x += player.dx;
        player.y += player.dy;
        if (player.x < player_size / 2) {
            player.x = player_size / 2;
        }
        if (player.y < player_size / 2) {
            player.y = player_size / 2;
        }
        if (player.x > width - player_size / 2) {
            player.x = width - player_size / 2;
        }
        if (player.y > height - player_size / 2) {
            player.y = height - player_size / 2;
        }
        // render(context.surface_ctx.display_data.?, color_background, color_player);
        // surface.attach(buffer, 0, 0);
        // surface.damageBuffer(0, 0, width, height);
        // surface.commit();
        // _ = display.flush();
    }
}

fn surfaceFrameListener(cb: *wl.Callback, event: wl.Callback.Event, context: *Context) void {
    switch (event) {
        .done => {
            cb.destroy();
            if (context.surface_ctx.surface) |surface| {
                const display_data = context.surface_ctx.display_data.?;
                const new_callback = surface.frame() catch |e| {
                    std.log.err("Failed to create frame callback: {s}", .{@errorName(e)});
                    return;
                };
                new_callback.setListener(*Context, surfaceFrameListener, context);
                render(display_data, color_background, color_player);
                surface.attach(context.surface_ctx.buffer, 0, 0);
                surface.damageBuffer(0, 0, width, height);
                context.surface_ctx.surface.?.commit();
            }
        },
    }
}

fn bufferListener(buffer: *wl.Buffer, event: wl.Buffer.Event, context: *SurfaceContext) void {
    _ = context;
    switch (event) {
        .release => {
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
        .ping => |evt| {
            xdg_wm_base.pong(evt.serial);
        },
    }
}

fn registryListener(registry: *wl.Registry, event: wl.Registry.Event, context: *Context) void {
    switch (event) {
        .global => |evt| {
            if (std.mem.orderZ(u8, evt.interface, wl.Compositor.getInterface().name) == .eq) {
                context.compositor = registry.bind(evt.name, wl.Compositor, 6) catch return;
            } else if (std.mem.orderZ(u8, evt.interface, wl.Shm.getInterface().name) == .eq) {
                context.shm = registry.bind(evt.name, wl.Shm, 1) catch return;
            } else if (std.mem.orderZ(u8, evt.interface, xdg.WmBase.getInterface().name) == .eq) {
                context.wm_base = registry.bind(evt.name, xdg.WmBase, 1) catch return;
            } else if (std.mem.orderZ(u8, evt.interface, wl.Seat.getInterface().name) == .eq) {
                context.seat = registry.bind(evt.name, wl.Seat, 1) catch return;
            }
        },
        .global_remove => {},
    }
}

fn keyboardListener(keyboard: *wl.Keyboard, event: wl.Keyboard.Event, context: *Context) void {
    _ = keyboard;
    switch (event) {
        .keymap => |evt| {
            defer std.posix.close(evt.fd);
            // TODO(Benjamin): This needs to map the fd from the event and read the keymap from it
            if (evt.format != .xkb_v1) {
                std.log.err("Invalid keymap format: {s}\n", .{@tagName(evt.format)});
                return;
            }
            const keymap = std.posix.mmap(null, evt.size, std.posix.PROT.READ, .{ .TYPE = .PRIVATE }, evt.fd, 0) catch |err| {
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
        .key => |evt| {
            const xs = context.xkb_state orelse return;

            const keycode = evt.key + 8;
            const keysym = xs.keyGetOneSym(keycode);
            if (keysym == .NoSymbol) return;

            switch (@intFromEnum(keysym)) {
                xkb.Keysym.Return,
                xkb.Keysym.KP_Enter,
                => {},
                xkb.Keysym.W, xkb.Keysym.w => {
                    if (evt.state == .pressed) {
                        player.dy += -5;
                    } else {
                        player.dy -= -5;
                    }
                },
                xkb.Keysym.A,
                xkb.Keysym.a,
                => {
                    if (evt.state == .pressed) {
                        player.dx += -5;
                    } else {
                        player.dx -= -5;
                    }
                },
                xkb.Keysym.S,
                xkb.Keysym.s,
                => {
                    if (evt.state == .pressed) {
                        player.dy += 5;
                    } else {
                        player.dy -= 5;
                    }
                },
                xkb.Keysym.D,
                xkb.Keysym.d,
                => {
                    if (evt.state == .pressed) {
                        player.dx += 5;
                    } else {
                        player.dx -= 5;
                    }
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
        .modifiers => |evt| {
            if (context.xkb_state) |xs| {
                _ = xs.updateMask(evt.mods_depressed, evt.mods_latched, evt.mods_locked, 0, 0, evt.group);
            }
        },
        .repeat_info => |evt| {
            context.*.key_repeat_delay = evt.delay;
            context.*.key_repeat_rate = evt.rate;
            std.debug.print("Keys will repeat after {d}ms at a rate of {d}/s", .{ evt.delay, evt.rate });
        },
    }
}

fn pointerListener(pointer: *wl.Pointer, event: wl.Pointer.Event, context: *Context) void {
    _ = pointer;
    _ = context;
    switch (event) {
        .enter => {},
        .leave => {},
        .button => |evt| {
            switch (evt.button) {
                input_event_codes.BTN_LEFT => {},
                input_event_codes.BTN_RIGHT => {},
                input_event_codes.BTN_MIDDLE => {},
                else => {},
            }
        },
        .axis => |evt| {
            switch (evt.axis) {
                .horizontal_scroll => {},
                .vertical_scroll => {},
                else => {},
            }
        },
        .motion => |evt| {
            _ = evt.surface_x;
            _ = evt.surface_y;
            _ = evt.time;
        },
        .axis_source => |evt| {
            switch (evt.axis_source) {
                .wheel => {},
                .finger => {},
                .continuous => {},
                else => {},
            }
        },
        .axis_discrete => |evt| {
            switch (evt.axis) {
                .horizontal_scroll => {},
                .vertical_scroll => {},
                else => {},
            }
        },
        .axis_stop => |evt| {
            switch (evt.axis) {
                .horizontal_scroll => {},
                .vertical_scroll => {},
                else => {},
            }
        },
        .frame => {
            // TODO: Between frame events, motion, axis, etc events are meant to be
            // accumulated into one atomic thing. You might have press down and move
            // to a new position happen at the same time for example.
        },
    }
}

fn seatListener(seat: *wl.Seat, event: wl.Seat.Event, context: *Context) void {
    switch (event) {
        .capabilities => |evt| {
            if (evt.capabilities.pointer) {
                context.pointer = seat.getPointer() catch return;
                const pointer = context.pointer.?;
                pointer.setListener(*Context, pointerListener, context);
            }
            if (evt.capabilities.keyboard) {
                context.keyboard = seat.getKeyboard() catch return;
                const keyboard = context.keyboard.?;
                keyboard.setListener(*Context, keyboardListener, context);
            }
        },
        .name => {},
    }
}

fn xdgSurfaceListener(xdg_surface: *xdg.Surface, event: xdg.Surface.Event, context: *SurfaceContext) void {
    switch (event) {
        .configure => |evt| {
            xdg_surface.ackConfigure(evt.serial);
            if (context.surface) |surface| {
                // Shouldn't get here without a display buffer I believe
                render(context.display_data.?, color_background, color_player);
                surface.attach(context.buffer, 0, 0);
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
