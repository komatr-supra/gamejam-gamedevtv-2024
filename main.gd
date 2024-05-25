extends Node2D

@export var falling_object_scene : PackedScene
var timer
var time_survived = 0.0
func _ready():
	timer = $CharacterBody2D/Timer
	timer.wait_time = 1.0 # spawn interval
	timer.connect("timeout", _on_FallingObjectTimer_timeout)
	timer.start()

func _on_FallingObjectTimer_timeout():
	var new_object = falling_object_scene.instantiate()
	add_child(new_object)
	new_object.position = Vector2(randf_range(0, get_viewport_rect().size.x), -10)

func _process(delta):
	time_survived += delta
	$timer.text = str(time_survived)
