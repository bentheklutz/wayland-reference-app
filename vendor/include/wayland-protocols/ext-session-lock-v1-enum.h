/* Generated by wayland-scanner 1.23.0 */

#ifndef EXT_SESSION_LOCK_V1_ENUM_PROTOCOL_H
#define EXT_SESSION_LOCK_V1_ENUM_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef EXT_SESSION_LOCK_V1_ERROR_ENUM
#define EXT_SESSION_LOCK_V1_ERROR_ENUM
enum ext_session_lock_v1_error {
	/**
	 * attempted to destroy session lock while locked
	 */
	EXT_SESSION_LOCK_V1_ERROR_INVALID_DESTROY = 0,
	/**
	 * unlock requested but locked event was never sent
	 */
	EXT_SESSION_LOCK_V1_ERROR_INVALID_UNLOCK = 1,
	/**
	 * given wl_surface already has a role
	 */
	EXT_SESSION_LOCK_V1_ERROR_ROLE = 2,
	/**
	 * given output already has a lock surface
	 */
	EXT_SESSION_LOCK_V1_ERROR_DUPLICATE_OUTPUT = 3,
	/**
	 * given wl_surface has a buffer attached or committed
	 */
	EXT_SESSION_LOCK_V1_ERROR_ALREADY_CONSTRUCTED = 4,
};
#endif /* EXT_SESSION_LOCK_V1_ERROR_ENUM */

#ifndef EXT_SESSION_LOCK_SURFACE_V1_ERROR_ENUM
#define EXT_SESSION_LOCK_SURFACE_V1_ERROR_ENUM
enum ext_session_lock_surface_v1_error {
	/**
	 * surface committed before first ack_configure request
	 */
	EXT_SESSION_LOCK_SURFACE_V1_ERROR_COMMIT_BEFORE_FIRST_ACK = 0,
	/**
	 * surface committed with a null buffer
	 */
	EXT_SESSION_LOCK_SURFACE_V1_ERROR_NULL_BUFFER = 1,
	/**
	 * failed to match ack'd width/height
	 */
	EXT_SESSION_LOCK_SURFACE_V1_ERROR_DIMENSIONS_MISMATCH = 2,
	/**
	 * serial provided in ack_configure is invalid
	 */
	EXT_SESSION_LOCK_SURFACE_V1_ERROR_INVALID_SERIAL = 3,
};
#endif /* EXT_SESSION_LOCK_SURFACE_V1_ERROR_ENUM */

#ifdef  __cplusplus
}
#endif

#endif
