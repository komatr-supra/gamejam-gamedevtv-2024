extends Node2D

@export var falling_object_scene : PackedScene
@export var fuel_collect_scene: PackedScene
@export var health_collect_scene: PackedScene
@export var fall_delay = 0.8

@onready var asteroid_timer = $AsteroidTimer
@onready var fuel_timer = $FuelTimer
@onready var health_timer = $HealthTimer
@onready var falling_object_area = $FallingObjectArea
@onready var timer_label = $GUILayer/MainGUIContainer/TopMarginContainer/GridContainer/RightMarginContainer/GridContainer/TimerLabel
@onready var health_progress_bar = $GUILayer/MainGUIContainer/TopMarginContainer/GridContainer/LeftMarginContainer/GridContainer/HealthProgressBar
@onready var player = $Player
@onready var end_scene = $GUILayer/EndScene
@onready var pause_scene = $GUILayer/PauseScene
@onready var victory_screen = $GUILayer/VictoryScreen
@onready var no_fuel_rich_text_label = $GUILayer/MainGUIContainer/TopMarginContainer/GridContainer/MidMarginContainer/NoFuelRichTextLabel
@onready var no_fuel_blink_timer = $GUILayer/MainGUIContainer/TopMarginContainer/GridContainer/MidMarginContainer/NoFuelBlinkTimer
@onready var shield_cooldown_label = $GUILayer/MainGUIContainer/BotMarginContainer/GridContainer/LeftMarginContainer/ShieldCooldownLabel

@onready var outside_grid_container = $GUILayer/MainGUIContainer/MidMarginContainer/GridContainer/CenterMarginContainer/OutsideGridContainer
@onready var outside_countdown_label = $GUILayer/MainGUIContainer/MidMarginContainer/GridContainer/CenterMarginContainer/OutsideGridContainer/CountdownLabel
@onready var fuel_progress_bar = $GUILayer/MainGUIContainer/MidMarginContainer/GridContainer/CenterMarginContainer/OutsideGridContainer/MarginContainer/CenterContainer/GridContainer/FuelProgressBar

@onready var audio_low_fuel: AudioStreamPlayer = $AudioLowFuel
@onready var audio_fuel: AudioStreamPlayer = $AudioFuel
@onready var audio_pickup_wrench: AudioStreamPlayer = $AudioPickupWrench

@onready var parallax_background: ParallaxBackground = $ParallaxBackground

var is_player_alive: bool = true
var game_end: bool = false
var sent_fuel_signal: bool = false
var player_has_shield: bool = true
var is_outside_screen: bool = false

signal game_win_signal
signal low_fuel_signal

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	# TODO Probably not the best way to do this
	get_tree().paused = true
	await parallax_background.bg_texture_5.texture.changed
	get_tree().paused = false
	
	fuel_progress_bar.scale = Vector2(0.5, 0.5)

	SystemData.player_fuel = SystemData.player_max_fuel
	SystemData.player_health = SystemData.player_max_health
	SystemData.time_left = SystemData.max_time
	SystemData.time_survived = 0
	SystemData.shield_health = SystemData.shield_max_health
	SystemData.health_collected = 0
	SystemData.fuel_collected = 0
	SystemData.time_outside_screen = 10

	health_progress_bar.max_value = SystemData.player_health

	asteroid_timer.connect("timeout", _on_FallingObjectTimer_timeout)
	asteroid_timer.start()

	game_win_signal.connect(game_win)
	low_fuel_signal.connect(no_fuel)

	fuel_timer.connect("timeout", _on_FuelTimer_timeout)
	health_timer.connect("timeout", _on_HealthTimer_timeout)

	player.connect("player_death_signal", player_death)
	player.connect("shield_destroyed_signal", shield_destroyed)

func _process(delta):
	var mils = fmod(SystemData.time_left, 1) * 100
	var secs = fmod(SystemData.time_left, 60)
	var mins = fmod(SystemData.time_left, 60 * 60) / 60
	var time_passed = "%02d:%02d:%02d" % [mins, secs, mils]
	if is_player_alive:
		if fall_delay > 0.3:
			fall_delay -= 0.00001
		if !game_end:
			SystemData.time_survived += delta
			SystemData.time_left -= delta
			timer_label.text = time_passed

		if SystemData.time_survived >= SystemData.max_time && !game_end:
			game_win()
			game_end = true

	health_progress_bar.value = SystemData.player_health + SystemData.shield_health
	fuel_progress_bar.value = SystemData.player_fuel

	if SystemData.player_fuel <= 25 && !sent_fuel_signal:
		low_fuel_signal.emit()

	if !player_has_shield && is_player_alive && !game_end:
		shield_cooldown_label.text = "SHIELD COOLDOWN: " + str(snappedf(player.shield_cooldown_timer.time_left, 0.1))

	if is_outside_screen && is_player_alive:
		SystemData.time_outside_screen -= delta

		if SystemData.time_outside_screen > 0:
			outside_countdown_label.text = str(snapped(SystemData.time_outside_screen, 1))
		elif SystemData.time_outside_screen <= 0:
			outside_grid_container.visible = false
			player.player_die()
	
	else:
		outside_grid_container.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_scene.visible = true
		get_tree().paused = true

func _on_FallingObjectTimer_timeout():
	asteroid_timer.wait_time = fall_delay
	var new_object = falling_object_scene.instantiate()
	add_child(new_object)
	new_object.connect("player_hit_signal", on_player_hit)
	new_object.position = Vector2(randi_range(16, (get_viewport_rect().size.x * 2) - 16), falling_object_area.global_position.y)

func _on_FuelTimer_timeout():
	var fuel_object = fuel_collect_scene.instantiate()
	add_child(fuel_object)
	fuel_object.connect("fuel_collected", _on_fuel_collected)
	fuel_object.position = Vector2(randi_range(16, (get_viewport_rect().size.x * 2) - 16), falling_object_area.global_position.y)

func _on_HealthTimer_timeout():
	var health_object = health_collect_scene.instantiate()
	add_child(health_object)
	health_object.connect("health_collected", _on_health_collected)
	health_object.position = Vector2(randi_range(16, (get_viewport_rect().size.x * 2) - 16), falling_object_area.global_position.y)

func _on_health_collected():
	audio_pickup_wrench.play()

func _on_fuel_collected():
	audio_fuel.play()

func on_player_hit():
	#if SystemData.shield_health > 0:
	if SystemData.shield_health > 0:
		SystemData.shield_health -= SystemData.collision_cost
		player.call_deferred("destroy_shield")
	else:
		SystemData.player_health -= SystemData.collision_cost
		if SystemData.player_health <= 0:
			player.player_die()
		else:
			player.flash()

func game_win():
	victory_screen.game_win()
	player.queue_free()

func no_fuel():
	no_fuel_blink_timer.start(0.5)

	if SystemData.player_fuel > 25:
		sent_fuel_signal = false
		no_fuel_rich_text_label.visible = false
		audio_low_fuel.stop()

	if SystemData.player_fuel <= 25 && is_player_alive:
		sent_fuel_signal = true

		if SystemData.player_fuel > 0:
			if !audio_low_fuel.playing:
				audio_low_fuel.play()
			no_fuel_rich_text_label.bbcode_text = "[center][img=100]res://sprites/Warning.png[/img]\nLOW FUEL![/center]"
		else:
			no_fuel_rich_text_label.bbcode_text = "[center][img=100]res://sprites/Warning.png[/img]\nNO FUEL LEFT![/center]"

		if no_fuel_rich_text_label.visible:
			no_fuel_rich_text_label.visible = false
		else:
			no_fuel_rich_text_label.visible = true

	if !is_player_alive:
		audio_low_fuel.stop()
		no_fuel_rich_text_label.visible = false

func shield_destroyed():
	if SystemData.shield_health <= 0:
		shield_cooldown_label.visible = true
		player_has_shield = false
	else:
		shield_cooldown_label.visible = false
		player_has_shield = true

func player_death():
	end_scene.game_over()
	is_player_alive = false

func _on_viewport_area_entered(area):
	if area.is_in_group("player"):
		if is_outside_screen:
			is_outside_screen = false

func _on_viewport_area_exited(area):
	if area.is_in_group("player"):
		if player.global_position.x >= 0 && player.global_position.x <= 2560 && player.global_position.y >= 0 && player.global_position.y <= 1440:
			outside_grid_container.visible = false
			SystemData.time_outside_screen = 10
			is_outside_screen = false
		else:
			outside_grid_container.visible = true
			is_outside_screen = true
