extends Node2D

@export var falling_object_scene : PackedScene
@export var fuel_collect_scene: PackedScene
@export var health_collect_scene: PackedScene
@export var fall_delay = 0.5

@onready var asteroid_timer = $AsteroidTimer
@onready var fuel_timer = $FuelTimer
@onready var health_timer = $HealthTimer
@onready var falling_object_area = $FallingObjectArea
@onready var timer_label = $GUILayer/GridContainer/TopMarginContainer/GridContainer/RightMarginContainer/GridContainer/TimerLabel
@onready var health_progress_bar = $GUILayer/GridContainer/TopMarginContainer/GridContainer/LeftMarginContainer/GridContainer/HealthProgressBar



var fuel_exists = false
var is_player_alive = true

func _ready():
	asteroid_timer.connect("timeout", _on_FallingObjectTimer_timeout)
	asteroid_timer.start()

	fuel_timer.connect("timeout", _on_FuelTimer_timeout)
	health_timer.connect("timeout", _on_HealthTimer_timeout)

func _process(delta):
	var mils = fmod(SystemData.time, 1) * 100
	var secs = fmod(SystemData.time, 60)
	var mins = fmod(SystemData.time, 60 * 60) / 60
	var time_passed = "%02d:%02d:%02d" % [mins, secs, mils]
	if is_player_alive:
		if fall_delay > 0.1:
			fall_delay -= 0.00001
		SystemData.time += delta
		timer_label.text = time_passed
	
	health_progress_bar.value = SystemData.player_health

func _on_FallingObjectTimer_timeout():
	asteroid_timer.wait_time = fall_delay
	var new_object = falling_object_scene.instantiate()
	add_child(new_object)
	new_object.position = Vector2(randi_range(16, get_viewport_rect().size.x - 16), falling_object_area.global_position.y)

func _on_FuelTimer_timeout():
	var fuel_object = fuel_collect_scene.instantiate()
	add_child(fuel_object)
	fuel_object.position = Vector2(randi_range(16, get_viewport_rect().size.x - 16), falling_object_area.global_position.y)

func _on_HealthTimer_timeout():
	var health_object = health_collect_scene.instantiate()
	add_child(health_object)
	health_object.position = Vector2(randi_range(16, get_viewport_rect().size.x - 16), falling_object_area.global_position.y)

func player_died():
	is_player_alive = false
