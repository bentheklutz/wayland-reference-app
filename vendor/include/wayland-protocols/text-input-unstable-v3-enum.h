/* Generated by wayland-scanner 1.23.0 */

#ifndef TEXT_INPUT_UNSTABLE_V3_ENUM_PROTOCOL_H
#define TEXT_INPUT_UNSTABLE_V3_ENUM_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef ZWP_TEXT_INPUT_V3_CHANGE_CAUSE_ENUM
#define ZWP_TEXT_INPUT_V3_CHANGE_CAUSE_ENUM
/**
 * @ingroup iface_zwp_text_input_v3
 * text change reason
 *
 * Reason for the change of surrounding text or cursor posision.
 */
enum zwp_text_input_v3_change_cause {
	/**
	 * input method caused the change
	 */
	ZWP_TEXT_INPUT_V3_CHANGE_CAUSE_INPUT_METHOD = 0,
	/**
	 * something else than the input method caused the change
	 */
	ZWP_TEXT_INPUT_V3_CHANGE_CAUSE_OTHER = 1,
};
#endif /* ZWP_TEXT_INPUT_V3_CHANGE_CAUSE_ENUM */

#ifndef ZWP_TEXT_INPUT_V3_CONTENT_HINT_ENUM
#define ZWP_TEXT_INPUT_V3_CONTENT_HINT_ENUM
/**
 * @ingroup iface_zwp_text_input_v3
 * content hint
 *
 * Content hint is a bitmask to allow to modify the behavior of the text
 * input.
 */
enum zwp_text_input_v3_content_hint {
	/**
	 * no special behavior
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_NONE = 0x0,
	/**
	 * suggest word completions
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_COMPLETION = 0x1,
	/**
	 * suggest word corrections
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_SPELLCHECK = 0x2,
	/**
	 * switch to uppercase letters at the start of a sentence
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_AUTO_CAPITALIZATION = 0x4,
	/**
	 * prefer lowercase letters
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_LOWERCASE = 0x8,
	/**
	 * prefer uppercase letters
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_UPPERCASE = 0x10,
	/**
	 * prefer casing for titles and headings (can be language dependent)
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_TITLECASE = 0x20,
	/**
	 * characters should be hidden
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_HIDDEN_TEXT = 0x40,
	/**
	 * typed text should not be stored
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_SENSITIVE_DATA = 0x80,
	/**
	 * just Latin characters should be entered
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_LATIN = 0x100,
	/**
	 * the text input is multiline
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_HINT_MULTILINE = 0x200,
};
#endif /* ZWP_TEXT_INPUT_V3_CONTENT_HINT_ENUM */

#ifndef ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_ENUM
#define ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_ENUM
/**
 * @ingroup iface_zwp_text_input_v3
 * content purpose
 *
 * The content purpose allows to specify the primary purpose of a text
 * input.
 *
 * This allows an input method to show special purpose input panels with
 * extra characters or to disallow some characters.
 */
enum zwp_text_input_v3_content_purpose {
	/**
	 * default input, allowing all characters
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_NORMAL = 0,
	/**
	 * allow only alphabetic characters
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_ALPHA = 1,
	/**
	 * allow only digits
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_DIGITS = 2,
	/**
	 * input a number (including decimal separator and sign)
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_NUMBER = 3,
	/**
	 * input a phone number
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_PHONE = 4,
	/**
	 * input an URL
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_URL = 5,
	/**
	 * input an email address
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_EMAIL = 6,
	/**
	 * input a name of a person
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_NAME = 7,
	/**
	 * input a password (combine with sensitive_data hint)
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_PASSWORD = 8,
	/**
	 * input is a numeric password (combine with sensitive_data hint)
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_PIN = 9,
	/**
	 * input a date
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_DATE = 10,
	/**
	 * input a time
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_TIME = 11,
	/**
	 * input a date and time
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_DATETIME = 12,
	/**
	 * input for a terminal
	 */
	ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_TERMINAL = 13,
};
#endif /* ZWP_TEXT_INPUT_V3_CONTENT_PURPOSE_ENUM */

#ifdef  __cplusplus
}
#endif

#endif
