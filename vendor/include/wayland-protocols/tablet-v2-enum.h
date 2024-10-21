/* Generated by wayland-scanner 1.23.0 */

#ifndef TABLET_V2_ENUM_PROTOCOL_H
#define TABLET_V2_ENUM_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef ZWP_TABLET_TOOL_V2_TYPE_ENUM
#define ZWP_TABLET_TOOL_V2_TYPE_ENUM
/**
 * @ingroup iface_zwp_tablet_tool_v2
 * a physical tool type
 *
 * Describes the physical type of a tool. The physical type of a tool
 * generally defines its base usage.
 *
 * The mouse tool represents a mouse-shaped tool that is not a relative
 * device but bound to the tablet's surface, providing absolute
 * coordinates.
 *
 * The lens tool is a mouse-shaped tool with an attached lens to
 * provide precision focus.
 */
enum zwp_tablet_tool_v2_type {
	/**
	 * Pen
	 */
	ZWP_TABLET_TOOL_V2_TYPE_PEN = 0x140,
	/**
	 * Eraser
	 */
	ZWP_TABLET_TOOL_V2_TYPE_ERASER = 0x141,
	/**
	 * Brush
	 */
	ZWP_TABLET_TOOL_V2_TYPE_BRUSH = 0x142,
	/**
	 * Pencil
	 */
	ZWP_TABLET_TOOL_V2_TYPE_PENCIL = 0x143,
	/**
	 * Airbrush
	 */
	ZWP_TABLET_TOOL_V2_TYPE_AIRBRUSH = 0x144,
	/**
	 * Finger
	 */
	ZWP_TABLET_TOOL_V2_TYPE_FINGER = 0x145,
	/**
	 * Mouse
	 */
	ZWP_TABLET_TOOL_V2_TYPE_MOUSE = 0x146,
	/**
	 * Lens
	 */
	ZWP_TABLET_TOOL_V2_TYPE_LENS = 0x147,
};
#endif /* ZWP_TABLET_TOOL_V2_TYPE_ENUM */

#ifndef ZWP_TABLET_TOOL_V2_CAPABILITY_ENUM
#define ZWP_TABLET_TOOL_V2_CAPABILITY_ENUM
/**
 * @ingroup iface_zwp_tablet_tool_v2
 * capability flags for a tool
 *
 * Describes extra capabilities on a tablet.
 *
 * Any tool must provide x and y values, extra axes are
 * device-specific.
 */
enum zwp_tablet_tool_v2_capability {
	/**
	 * Tilt axes
	 */
	ZWP_TABLET_TOOL_V2_CAPABILITY_TILT = 1,
	/**
	 * Pressure axis
	 */
	ZWP_TABLET_TOOL_V2_CAPABILITY_PRESSURE = 2,
	/**
	 * Distance axis
	 */
	ZWP_TABLET_TOOL_V2_CAPABILITY_DISTANCE = 3,
	/**
	 * Z-rotation axis
	 */
	ZWP_TABLET_TOOL_V2_CAPABILITY_ROTATION = 4,
	/**
	 * Slider axis
	 */
	ZWP_TABLET_TOOL_V2_CAPABILITY_SLIDER = 5,
	/**
	 * Wheel axis
	 */
	ZWP_TABLET_TOOL_V2_CAPABILITY_WHEEL = 6,
};
#endif /* ZWP_TABLET_TOOL_V2_CAPABILITY_ENUM */

#ifndef ZWP_TABLET_TOOL_V2_BUTTON_STATE_ENUM
#define ZWP_TABLET_TOOL_V2_BUTTON_STATE_ENUM
/**
 * @ingroup iface_zwp_tablet_tool_v2
 * physical button state
 *
 * Describes the physical state of a button that produced the button event.
 */
enum zwp_tablet_tool_v2_button_state {
	/**
	 * button is not pressed
	 */
	ZWP_TABLET_TOOL_V2_BUTTON_STATE_RELEASED = 0,
	/**
	 * button is pressed
	 */
	ZWP_TABLET_TOOL_V2_BUTTON_STATE_PRESSED = 1,
};
#endif /* ZWP_TABLET_TOOL_V2_BUTTON_STATE_ENUM */

#ifndef ZWP_TABLET_TOOL_V2_ERROR_ENUM
#define ZWP_TABLET_TOOL_V2_ERROR_ENUM
enum zwp_tablet_tool_v2_error {
	/**
	 * given wl_surface has another role
	 */
	ZWP_TABLET_TOOL_V2_ERROR_ROLE = 0,
};
#endif /* ZWP_TABLET_TOOL_V2_ERROR_ENUM */

#ifndef ZWP_TABLET_PAD_RING_V2_SOURCE_ENUM
#define ZWP_TABLET_PAD_RING_V2_SOURCE_ENUM
/**
 * @ingroup iface_zwp_tablet_pad_ring_v2
 * ring axis source
 *
 * Describes the source types for ring events. This indicates to the
 * client how a ring event was physically generated; a client may
 * adjust the user interface accordingly. For example, events
 * from a "finger" source may trigger kinetic scrolling.
 */
enum zwp_tablet_pad_ring_v2_source {
	/**
	 * finger
	 */
	ZWP_TABLET_PAD_RING_V2_SOURCE_FINGER = 1,
};
#endif /* ZWP_TABLET_PAD_RING_V2_SOURCE_ENUM */

#ifndef ZWP_TABLET_PAD_STRIP_V2_SOURCE_ENUM
#define ZWP_TABLET_PAD_STRIP_V2_SOURCE_ENUM
/**
 * @ingroup iface_zwp_tablet_pad_strip_v2
 * strip axis source
 *
 * Describes the source types for strip events. This indicates to the
 * client how a strip event was physically generated; a client may
 * adjust the user interface accordingly. For example, events
 * from a "finger" source may trigger kinetic scrolling.
 */
enum zwp_tablet_pad_strip_v2_source {
	/**
	 * finger
	 */
	ZWP_TABLET_PAD_STRIP_V2_SOURCE_FINGER = 1,
};
#endif /* ZWP_TABLET_PAD_STRIP_V2_SOURCE_ENUM */

#ifndef ZWP_TABLET_PAD_V2_BUTTON_STATE_ENUM
#define ZWP_TABLET_PAD_V2_BUTTON_STATE_ENUM
/**
 * @ingroup iface_zwp_tablet_pad_v2
 * physical button state
 *
 * Describes the physical state of a button that caused the button
 * event.
 */
enum zwp_tablet_pad_v2_button_state {
	/**
	 * the button is not pressed
	 */
	ZWP_TABLET_PAD_V2_BUTTON_STATE_RELEASED = 0,
	/**
	 * the button is pressed
	 */
	ZWP_TABLET_PAD_V2_BUTTON_STATE_PRESSED = 1,
};
#endif /* ZWP_TABLET_PAD_V2_BUTTON_STATE_ENUM */

#ifdef  __cplusplus
}
#endif

#endif
