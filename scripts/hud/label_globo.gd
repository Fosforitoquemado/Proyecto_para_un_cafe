extends Label

@export var max_width := 400
@export var max_font_size := 48
@export var min_font_size := 14

func ajustar_fuente():

	var font_size = max_font_size

	while font_size >= min_font_size:

		add_theme_font_size_override("font_size", font_size)

		await get_tree().process_frame

		var size = get_theme_font("font").get_multiline_string_size(
			text,
			horizontal_alignment,
			max_width,
			font_size
		)

		if size.x <= max_width:
			break

		font_size -= 1
