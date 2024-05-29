extends Node2D

@export var falling_object_scene : PackedScene
@export var fuel_collect_scene: PackedScene
@export var health_collect_scene: PackedScene
@export var fall_delay = 0.5

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



var is_player_alive: bool = true
var game_end: bool = false
var sent_fuel_signal: bool = false
var player_has_shield: bool = true

signal game_win_signal
signal low_fuel_signal

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

	SystemData.player_fuel = 100
	SystemData.player_health = 15
	SystemData.time_left = 180
	SystemData.time_survived = 0
	SystemData.shield_health = 5
	SystemData.health_collected = 0
	SystemData.fuel_collected = 0

	health_progress_bar.max_value = SystemData.player_health + SystemData.shield_health

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
		if fall_delay > 0.1:
			fall_delay -= 0.00001
		if !game_end:
			SystemData.time_survived += delta
			SystemData.time_left -= delta
			timer_label.text = time_passed

		if SystemData.time_survived >= SystemData.max_time && !game_end:
			game_win()
			game_end = true

	health_progress_bar.value = SystemData.player_health + SystemData.shield_health

	if SystemData.player_fuel <= 25 && !sent_fuel_signal:
		low_fuel_signal.emit()

	if !player_has_shield && is_player_alive && !game_end:
		shield_cooldown_label.text = "SHIELD COOLDOWN: " + str(snappedf(player.shield_cooldown_timer.time_left, 0.1))

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
	fuel_object.position = Vector2(randi_range(16, (get_viewport_rect().size.x * 2) - 16), falling_object_area.global_position.y)

func _on_HealthTimer_timeout():
	var health_object = health_collect_scene.instantiate()
	add_child(health_object)
	health_object.position = Vector2(randi_range(16, (get_viewport_rect().size.x * 2) - 16), falling_object_area.global_position.y)

func on_player_hit():
	if SystemData.shield_health > 0:
		SystemData.shield_health -= SystemData.collision_cost
		if SystemData.shield_health <= 0:
			player.destroy_shield()
	else:
		SystemData.player_health -= SystemData.collision_cost
		if SystemData.player_health <= 0:
			player.player_die()

func game_win():
	victory_screen.game_win()
	player.queue_free()

func no_fuel():
	no_fuel_blink_timer.start(0.5)

	if SystemData.player_fuel > 25:
		sent_fuel_signal = false

	if SystemData.player_fuel <= 25 && is_player_alive:
		sent_fuel_signal = true

		if SystemData.player_fuel > 0:
			no_fuel_rich_text_label.bbcode_text = "[center][img=100]res://sprites/WarningPlaceholder.png[/img]\nLOW FUEL![/center]"
		else:
			no_fuel_rich_text_label.bbcode_text = "[center][img=100]res://sprites/WarningPlaceholder.png[/img]\nNO FUEL LEFT![/center]"

		if no_fuel_rich_text_label.visible:
			no_fuel_rich_text_label.visible = false
		else:
			no_fuel_rich_text_label.visible = true

	if !is_player_alive:
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
