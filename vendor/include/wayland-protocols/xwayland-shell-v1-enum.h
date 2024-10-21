/* Generated by wayland-scanner 1.23.0 */

#ifndef XWAYLAND_SHELL_V1_ENUM_PROTOCOL_H
#define XWAYLAND_SHELL_V1_ENUM_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef XWAYLAND_SHELL_V1_ERROR_ENUM
#define XWAYLAND_SHELL_V1_ERROR_ENUM
enum xwayland_shell_v1_error {
	/**
	 * given wl_surface has another role
	 */
	XWAYLAND_SHELL_V1_ERROR_ROLE = 0,
};
#endif /* XWAYLAND_SHELL_V1_ERROR_ENUM */

#ifndef XWAYLAND_SURFACE_V1_ERROR_ENUM
#define XWAYLAND_SURFACE_V1_ERROR_ENUM
enum xwayland_surface_v1_error {
	/**
	 * given wl_surface is already associated with an X11 window
	 */
	XWAYLAND_SURFACE_V1_ERROR_ALREADY_ASSOCIATED = 0,
	/**
	 * serial was not valid
	 */
	XWAYLAND_SURFACE_V1_ERROR_INVALID_SERIAL = 1,
};
#endif /* XWAYLAND_SURFACE_V1_ERROR_ENUM */

#ifdef  __cplusplus
}
#endif

#endif
