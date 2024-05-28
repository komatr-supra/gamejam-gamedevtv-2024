extends Node

var slideshow_scene: PackedScene

func _on_start_button_up():
	get_tree().change_scene_to_file("res://scenes/slideshow/intro.tscn")
