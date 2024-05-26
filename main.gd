extends Node2D

@export var falling_object_scene : PackedScene
@export var fall_delay = 0.5
var timer
var is_player_alive = true
func _ready():
	preload("res://jet.gd")
	preload("res://particle_static.tscn")
	preload("res://falling_object.tscn")
	timer = $Timer	
	timer.connect("timeout", _on_FallingObjectTimer_timeout)
	timer.start()

func _on_FallingObjectTimer_timeout():
	timer.wait_time = fall_delay
	var new_object = falling_object_scene.instantiate()
	add_child(new_object)
	new_object.position = Vector2(randf_range(-400, get_viewport_rect().size.x  + 400), -10)

func player_died():
	
	is_player_alive = false

func _process(delta):
	
	if is_player_alive:
		if fall_delay > 0.1:
			fall_delay -= 0.00001
		SystemData.time += delta
		$timer.text = str(SystemData.time)
