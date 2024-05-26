extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


const high = Color("b5f173")
const medium = Color("e7ab73")
const low = Color("e74e36")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if value > 70:
		tint_progress = high
	elif value > 30:
		tint_progress = medium
	else:
		tint_progress = low
