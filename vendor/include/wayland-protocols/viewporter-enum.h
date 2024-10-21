/* Generated by wayland-scanner 1.23.0 */

#ifndef VIEWPORTER_ENUM_PROTOCOL_H
#define VIEWPORTER_ENUM_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef WP_VIEWPORTER_ERROR_ENUM
#define WP_VIEWPORTER_ERROR_ENUM
enum wp_viewporter_error {
	/**
	 * the surface already has a viewport object associated
	 */
	WP_VIEWPORTER_ERROR_VIEWPORT_EXISTS = 0,
};
#endif /* WP_VIEWPORTER_ERROR_ENUM */

#ifndef WP_VIEWPORT_ERROR_ENUM
#define WP_VIEWPORT_ERROR_ENUM
enum wp_viewport_error {
	/**
	 * negative or zero values in width or height
	 */
	WP_VIEWPORT_ERROR_BAD_VALUE = 0,
	/**
	 * destination size is not integer
	 */
	WP_VIEWPORT_ERROR_BAD_SIZE = 1,
	/**
	 * source rectangle extends outside of the content area
	 */
	WP_VIEWPORT_ERROR_OUT_OF_BUFFER = 2,
	/**
	 * the wl_surface was destroyed
	 */
	WP_VIEWPORT_ERROR_NO_SURFACE = 3,
};
#endif /* WP_VIEWPORT_ERROR_ENUM */

#ifdef  __cplusplus
}
#endif

#endif