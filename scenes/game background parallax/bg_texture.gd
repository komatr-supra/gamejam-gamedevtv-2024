extends TextureRect

var noise_texture_2d: NoiseTexture2D = texture
var fast_noise_lite: FastNoiseLite = noise_texture_2d.noise

func set_seed(seed: int) -> void:
	hide()
	fast_noise_lite.seed = seed
	await noise_texture_2d.changed
	show()

