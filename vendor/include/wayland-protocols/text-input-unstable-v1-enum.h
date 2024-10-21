/* Generated by wayland-scanner 1.23.0 */

#ifndef TEXT_INPUT_UNSTABLE_V1_ENUM_PROTOCOL_H
#define TEXT_INPUT_UNSTABLE_V1_ENUM_PROTOCOL_H

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef ZWP_TEXT_INPUT_V1_CONTENT_HINT_ENUM
#define ZWP_TEXT_INPUT_V1_CONTENT_HINT_ENUM
/**
 * @ingroup iface_zwp_text_input_v1
 * content hint
 *
 * Content hint is a bitmask to allow to modify the behavior of the text
 * input.
 */
enum zwp_text_input_v1_content_hint {
	/**
	 * no special behaviour
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_NONE = 0x0,
	/**
	 * auto completion, correction and capitalization
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_DEFAULT = 0x7,
	/**
	 * hidden and sensitive text
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_PASSWORD = 0xc0,
	/**
	 * suggest word completions
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_AUTO_COMPLETION = 0x1,
	/**
	 * suggest word corrections
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_AUTO_CORRECTION = 0x2,
	/**
	 * switch to uppercase letters at the start of a sentence
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_AUTO_CAPITALIZATION = 0x4,
	/**
	 * prefer lowercase letters
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_LOWERCASE = 0x8,
	/**
	 * prefer uppercase letters
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_UPPERCASE = 0x10,
	/**
	 * prefer casing for titles and headings (can be language dependent)
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_TITLECASE = 0x20,
	/**
	 * characters should be hidden
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_HIDDEN_TEXT = 0x40,
	/**
	 * typed text should not be stored
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_SENSITIVE_DATA = 0x80,
	/**
	 * just latin characters should be entered
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_LATIN = 0x100,
	/**
	 * the text input is multiline
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_HINT_MULTILINE = 0x200,
};
#endif /* ZWP_TEXT_INPUT_V1_CONTENT_HINT_ENUM */

#ifndef ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_ENUM
#define ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_ENUM
/**
 * @ingroup iface_zwp_text_input_v1
 * content purpose
 *
 * The content purpose allows to specify the primary purpose of a text
 * input.
 *
 * This allows an input method to show special purpose input panels with
 * extra characters or to disallow some characters.
 */
enum zwp_text_input_v1_content_purpose {
	/**
	 * default input, allowing all characters
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_NORMAL = 0,
	/**
	 * allow only alphabetic characters
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_ALPHA = 1,
	/**
	 * allow only digits
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_DIGITS = 2,
	/**
	 * input a number (including decimal separator and sign)
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_NUMBER = 3,
	/**
	 * input a phone number
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_PHONE = 4,
	/**
	 * input an URL
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_URL = 5,
	/**
	 * input an email address
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_EMAIL = 6,
	/**
	 * input a name of a person
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_NAME = 7,
	/**
	 * input a password (combine with password or sensitive_data hint)
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_PASSWORD = 8,
	/**
	 * input a date
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_DATE = 9,
	/**
	 * input a time
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_TIME = 10,
	/**
	 * input a date and time
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_DATETIME = 11,
	/**
	 * input for a terminal
	 */
	ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_TERMINAL = 12,
};
#endif /* ZWP_TEXT_INPUT_V1_CONTENT_PURPOSE_ENUM */

#ifndef ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_ENUM
#define ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_ENUM
enum zwp_text_input_v1_preedit_style {
	/**
	 * default style for composing text
	 */
	ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_DEFAULT = 0,
	/**
	 * style should be the same as in non-composing text
	 */
	ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_NONE = 1,
	ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_ACTIVE = 2,
	ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_INACTIVE = 3,
	ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_HIGHLIGHT = 4,
	ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_UNDERLINE = 5,
	ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_SELECTION = 6,
	ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_INCORRECT = 7,
};
#endif /* ZWP_TEXT_INPUT_V1_PREEDIT_STYLE_ENUM */

#ifndef ZWP_TEXT_INPUT_V1_TEXT_DIRECTION_ENUM
#define ZWP_TEXT_INPUT_V1_TEXT_DIRECTION_ENUM
enum zwp_text_input_v1_text_direction {
	/**
	 * automatic text direction based on text and language
	 */
	ZWP_TEXT_INPUT_V1_TEXT_DIRECTION_AUTO = 0,
	/**
	 * left-to-right
	 */
	ZWP_TEXT_INPUT_V1_TEXT_DIRECTION_LTR = 1,
	/**
	 * right-to-left
	 */
	ZWP_TEXT_INPUT_V1_TEXT_DIRECTION_RTL = 2,
};
#endif /* ZWP_TEXT_INPUT_V1_TEXT_DIRECTION_ENUM */

#ifdef  __cplusplus
}
#endif

#endif
