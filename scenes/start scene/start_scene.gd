extends Node2D

func _ready():
	var part = preload("res://scenes/falling objects/particles_falling_objects.tscn")
func start_game():
	get_tree().change_scene_to_file("res://scenes/main game scene/game_scene.tscn")
