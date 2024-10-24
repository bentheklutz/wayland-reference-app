/* Generated by wayland-scanner 1.23.0 */

#ifndef LINUX_DMABUF_V1_ENUM_PROTOCOL_H
#define LINUX_DMABUF_V1_ENUM_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_ENUM
#define ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_ENUM
enum zwp_linux_buffer_params_v1_error {
	/**
	 * the dmabuf_batch object has already been used to create a wl_buffer
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_ALREADY_USED = 0,
	/**
	 * plane index out of bounds
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_PLANE_IDX = 1,
	/**
	 * the plane index was already set
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_PLANE_SET = 2,
	/**
	 * missing or too many planes to create a buffer
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_INCOMPLETE = 3,
	/**
	 * format not supported
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_INVALID_FORMAT = 4,
	/**
	 * invalid width or height
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_INVALID_DIMENSIONS = 5,
	/**
	 * offset + stride * height goes out of dmabuf bounds
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_OUT_OF_BOUNDS = 6,
	/**
	 * invalid wl_buffer resulted from importing dmabufs via                the create_immed request on given buffer_params
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_INVALID_WL_BUFFER = 7,
};
#endif /* ZWP_LINUX_BUFFER_PARAMS_V1_ERROR_ENUM */

#ifndef ZWP_LINUX_BUFFER_PARAMS_V1_FLAGS_ENUM
#define ZWP_LINUX_BUFFER_PARAMS_V1_FLAGS_ENUM
enum zwp_linux_buffer_params_v1_flags {
	/**
	 * contents are y-inverted
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_FLAGS_Y_INVERT = 1,
	/**
	 * content is interlaced
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_FLAGS_INTERLACED = 2,
	/**
	 * bottom field first
	 */
	ZWP_LINUX_BUFFER_PARAMS_V1_FLAGS_BOTTOM_FIRST = 4,
};
#endif /* ZWP_LINUX_BUFFER_PARAMS_V1_FLAGS_ENUM */

#ifndef ZWP_LINUX_DMABUF_FEEDBACK_V1_TRANCHE_FLAGS_ENUM
#define ZWP_LINUX_DMABUF_FEEDBACK_V1_TRANCHE_FLAGS_ENUM
enum zwp_linux_dmabuf_feedback_v1_tranche_flags {
	/**
	 * direct scan-out tranche
	 */
	ZWP_LINUX_DMABUF_FEEDBACK_V1_TRANCHE_FLAGS_SCANOUT = 1,
};
#endif /* ZWP_LINUX_DMABUF_FEEDBACK_V1_TRANCHE_FLAGS_ENUM */

#ifdef  __cplusplus
}
#endif

#endif
