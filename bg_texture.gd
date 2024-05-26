extends TextureRect

func _init() -> void:
	texture.noise.seed = randi()
