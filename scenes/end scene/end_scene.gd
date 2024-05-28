extends Control

@onready var survival_time = $MarginContainer/GridContainer/SurvivalTime

func _ready():
	self.hide()

func game_over():
	var mils = fmod(SystemData.time_survived, 1) * 100
	var secs = fmod(SystemData.time_survived, 60)
	var mins = fmod(SystemData.time_survived, 60 * 60) / 60
	var time_passed = "%02d:%02d:%02d" % [mins, secs, mils]
	show()
	survival_time.text = time_passed

func _on_try_again_button_up():
	get_tree().change_scene_to_file("res://scenes/main game scene/game_scene.tscn")

func _on_menu_button_up():
	get_tree().change_scene_to_file("res://scenes/new start scene/menu.tscn")
