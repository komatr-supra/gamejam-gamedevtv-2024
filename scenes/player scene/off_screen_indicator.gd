extends Node2D

@onready var indicator: TextureRect = $Indicator
var camera: Camera2D
var on_screen = true
var viewport_center: Vector2
var viewport_min: Vector2
var viewport_max: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_2d()
	viewport_center = Vector2(Vector2(get_viewport_rect().size) / camera.zoom) / 2.0
	viewport_min = (viewport_center - Vector2(60, 60)) * -1
	viewport_max = (viewport_center - Vector2(60, 60))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if on_screen:
		indicator.hide()
	else:
		indicator.show()
		var indicator_position = camera.to_local(global_position)
		indicator.set_global_position(viewport_center + indicator_position.clamp(viewport_min, viewport_max))

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true
