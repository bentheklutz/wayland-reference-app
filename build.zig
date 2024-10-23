const std = @import("std");

const Scanner = @import("zig-wayland").Scanner;

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Need to figure out how to restrict to linux without building for musl specifically
    // Restrict to linux. I'm not aware of any wayland compositors for windows
    // const target = b.resolveTargetQuery(.{
    //     .os_tag = .linux,
    // });
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    // In zig 0.13.0 this works fine. In zig master (0.14.x-dev) this fails
    // because Scanner can't find src/scanner.zig (from the zig-wayland project)
    const scanner = Scanner.create(b, .{
        .wayland_xml_path = "vendor/share/wayland/wayland.xml",
        .wayland_protocols_path = "vendor/share/wayland-protocols",
    });

    const wayland = b.createModule(.{ .root_source_file = scanner.result });

    scanner.addSystemProtocol("stable/xdg-shell/xdg-shell.xml");
    scanner.generate("wl_compositor", 1);
    scanner.generate("wl_shm", 1);
    scanner.generate("wl_seat", 1);
    scanner.generate("xdg_wm_base", 1);

    const xkbcommon = b.dependency("zig-xkbcommon", .{}).module("xkbcommon");

    const exe = b.addExecutable(.{
        .name = "app",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("wayland", wayland);
    exe.root_module.addImport("xkbcommon", xkbcommon);
    exe.addLibraryPath(.{ .cwd_relative = "vendor/lib64" });
    exe.addIncludePath(.{ .cwd_relative = "vendor/include" });
    exe.linkLibC();
    exe.linkSystemLibrary("wayland-client");
    exe.linkSystemLibrary("xkbcommon");
    exe.linkSystemLibrary("pipewire-0.3");
    scanner.addCSource(exe);

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
