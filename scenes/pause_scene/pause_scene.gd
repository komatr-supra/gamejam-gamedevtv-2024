extends Control

func _ready():
	self.hide()

func _on_resume_button_up():
	self.hide()
	get_tree().paused = false

func _on_menu_button_up():
	get_tree().paused = false
	SceneTransition.change_scene_to_file("res://scenes/new start scene/menu.tscn")
