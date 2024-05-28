extends Node

var slideshow_scene: PackedScene

func _ready():
	$RigidBody2D/particles.emitting = true
	$GPUParticles2D.emitting = true
	$Node2D/CPUParticles2D.emitting = true

func _on_start_button_up():
	get_tree().change_scene_to_file("res://scenes/slideshow/intro.tscn")
