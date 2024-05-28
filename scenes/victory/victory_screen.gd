extends Control

func _ready():
	self.hide()

func _on_try_again_button_up():
	get_tree().change_scene_to_file("res://scenes/main game scene/game_scene.tscn")

func _on_menu_button_up():
	get_tree().change_scene_to_file("res://scenes/new start scene/menu.tscn")
