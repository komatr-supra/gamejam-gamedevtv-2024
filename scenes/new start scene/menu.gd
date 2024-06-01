extends Node

@onready var music_sprite = $MusicButton/AnimatedSprite2D
@onready var sfx_sprite = $SFXButton/AnimatedSprite2D


var music_mouse_in: bool = false
var sfx_mouse_in: bool = false
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready():
	$RigidBody2D/particles.emitting = true
	$GPUParticles2D.emitting = true
	$Node2D/CPUParticles2D.emitting = true

func _process(delta):
	if AudioServer.is_bus_mute(music_bus):
		music_sprite.animation = "sound_off"
	else:
		music_sprite.animation = "sound_on"

	if AudioServer.is_bus_mute(sfx_bus):
		sfx_sprite.animation = "sound_off"
	else:
		sfx_sprite.animation = "sound_on"

func _on_start_button_up():
	SceneTransition.change_scene_to_file("res://scenes/slideshow/intro.tscn")

func _on_music_button_mouse_entered():
	music_mouse_in = true
func _on_music_button_mouse_exited():
	music_mouse_in = false

func _on_sfx_button_mouse_entered():
	sfx_mouse_in = true
func _on_sfx_button_mouse_exited():
	sfx_mouse_in = false

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && music_mouse_in:
		AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && sfx_mouse_in:
		AudioServer.set_bus_mute(sfx_bus, not AudioServer.is_bus_mute(sfx_bus))
