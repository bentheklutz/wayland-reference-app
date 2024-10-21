/* Generated by wayland-scanner 1.23.0 */

#ifndef EXT_IMAGE_COPY_CAPTURE_V1_ENUM_PROTOCOL_H
#define EXT_IMAGE_COPY_CAPTURE_V1_ENUM_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef EXT_IMAGE_COPY_CAPTURE_MANAGER_V1_ERROR_ENUM
#define EXT_IMAGE_COPY_CAPTURE_MANAGER_V1_ERROR_ENUM
enum ext_image_copy_capture_manager_v1_error {
	/**
	 * invalid option flag
	 */
	EXT_IMAGE_COPY_CAPTURE_MANAGER_V1_ERROR_INVALID_OPTION = 1,
};
#endif /* EXT_IMAGE_COPY_CAPTURE_MANAGER_V1_ERROR_ENUM */

#ifndef EXT_IMAGE_COPY_CAPTURE_MANAGER_V1_OPTIONS_ENUM
#define EXT_IMAGE_COPY_CAPTURE_MANAGER_V1_OPTIONS_ENUM
enum ext_image_copy_capture_manager_v1_options {
	/**
	 * paint cursors onto captured frames
	 */
	EXT_IMAGE_COPY_CAPTURE_MANAGER_V1_OPTIONS_PAINT_CURSORS = 1,
};
#endif /* EXT_IMAGE_COPY_CAPTURE_MANAGER_V1_OPTIONS_ENUM */

#ifndef EXT_IMAGE_COPY_CAPTURE_SESSION_V1_ERROR_ENUM
#define EXT_IMAGE_COPY_CAPTURE_SESSION_V1_ERROR_ENUM
enum ext_image_copy_capture_session_v1_error {
	/**
	 * create_frame sent before destroying previous frame
	 */
	EXT_IMAGE_COPY_CAPTURE_SESSION_V1_ERROR_DUPLICATE_FRAME = 1,
};
#endif /* EXT_IMAGE_COPY_CAPTURE_SESSION_V1_ERROR_ENUM */

#ifndef EXT_IMAGE_COPY_CAPTURE_FRAME_V1_ERROR_ENUM
#define EXT_IMAGE_COPY_CAPTURE_FRAME_V1_ERROR_ENUM
enum ext_image_copy_capture_frame_v1_error {
	/**
	 * capture sent without attach_buffer
	 */
	EXT_IMAGE_COPY_CAPTURE_FRAME_V1_ERROR_NO_BUFFER = 1,
	/**
	 * invalid buffer damage
	 */
	EXT_IMAGE_COPY_CAPTURE_FRAME_V1_ERROR_INVALID_BUFFER_DAMAGE = 2,
	/**
	 * capture request has been sent
	 */
	EXT_IMAGE_COPY_CAPTURE_FRAME_V1_ERROR_ALREADY_CAPTURED = 3,
};
#endif /* EXT_IMAGE_COPY_CAPTURE_FRAME_V1_ERROR_ENUM */

#ifndef EXT_IMAGE_COPY_CAPTURE_FRAME_V1_FAILURE_REASON_ENUM
#define EXT_IMAGE_COPY_CAPTURE_FRAME_V1_FAILURE_REASON_ENUM
enum ext_image_copy_capture_frame_v1_failure_reason {
	/**
	 * unknown runtime error
	 *
	 * An unspecified runtime error has occurred. The client may
	 * retry.
	 */
	EXT_IMAGE_COPY_CAPTURE_FRAME_V1_FAILURE_REASON_UNKNOWN = 0,
	/**
	 * buffer constraints mismatch
	 *
	 * The buffer submitted by the client doesn't match the latest
	 * session constraints. The client should re-allocate its buffers
	 * and retry.
	 */
	EXT_IMAGE_COPY_CAPTURE_FRAME_V1_FAILURE_REASON_BUFFER_CONSTRAINTS = 1,
	/**
	 * session is no longer available
	 *
	 * The session has stopped. See
	 * ext_image_copy_capture_session_v1.stopped.
	 */
	EXT_IMAGE_COPY_CAPTURE_FRAME_V1_FAILURE_REASON_STOPPED = 2,
};
#endif /* EXT_IMAGE_COPY_CAPTURE_FRAME_V1_FAILURE_REASON_ENUM */

#ifndef EXT_IMAGE_COPY_CAPTURE_CURSOR_SESSION_V1_ERROR_ENUM
#define EXT_IMAGE_COPY_CAPTURE_CURSOR_SESSION_V1_ERROR_ENUM
enum ext_image_copy_capture_cursor_session_v1_error {
	/**
	 * get_capture_session sent twice
	 */
	EXT_IMAGE_COPY_CAPTURE_CURSOR_SESSION_V1_ERROR_DUPLICATE_SESSION = 1,
};
#endif /* EXT_IMAGE_COPY_CAPTURE_CURSOR_SESSION_V1_ERROR_ENUM */

#ifdef  __cplusplus
}
#endif

#endif
