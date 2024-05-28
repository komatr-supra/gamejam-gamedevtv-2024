extends TextureRect

var noise_texture_2d: NoiseTexture2D = texture
var fast_noise_lite: FastNoiseLite = noise_texture_2d.noise

func _init() -> void:
	fast_noise_lite.seed = randi()

func _on_option_button_1_option_color_changed(color: String) -> void:
	noise_texture_2d.color_ramp.set_color(0, Color(color))

func _on_option_button_2_option_color_changed(color: String) -> void:
	noise_texture_2d.color_ramp.set_color(1, Color(color))
