extends Node2D

@onready var indicator: TextureRect = $Indicator
const indicator_offset: Vector2 = Vector2(0, 0)
var camera: Camera2D
var on_screen = true
var viewport_center: Vector2
var border_offset: Vector2 = Vector2(40, 60)
var max_indicator_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_2d()
	viewport_center = Vector2(Vector2(get_viewport().size) / camera.zoom) / 2.0
	max_indicator_position = viewport_center - border_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if on_screen:
		indicator.hide()
	else:
		indicator.show()
		var local_to_camera = camera.to_local(global_position)
		var indicator_position = Vector2(local_to_camera.x, local_to_camera.y)
		if indicator_position.abs().aspect() > max_indicator_position.aspect():
			indicator_position *= max_indicator_position.x / abs(indicator_position.x)
		else:
			indicator_position *= max_indicator_position.y / abs(indicator_position.y)
		indicator.set_global_position(viewport_center + indicator_position - indicator_offset)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true
