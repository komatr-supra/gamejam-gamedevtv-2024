extends TextureRect

var noise_texture_2d: NoiseTexture2D = texture
var fast_noise_lite: FastNoiseLite = noise_texture_2d.noise

func _init() -> void:
	fast_noise_lite.seed = randi()
