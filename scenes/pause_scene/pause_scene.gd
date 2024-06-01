extends Control

@onready var music_sprite = $MusicButton/AnimatedSprite2D
@onready var sfx_sprite = $SFXButton/AnimatedSprite2D

var music_mouse_in: bool = false
var sfx_mouse_in: bool = false

var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready():
	self.hide()

func _on_resume_button_up():
	self.hide()
	get_tree().paused = false

func _on_menu_button_up():
	get_tree().paused = false
	SceneTransition.change_scene_to_file("res://scenes/new start scene/menu.tscn")

func _on_music_button_up():
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
	if AudioServer.is_bus_mute(music_bus):
		music_sprite.animation = "sound_off"
	else:
		music_sprite.animation = "sound_on"

func _on_sfx_button_up():
	AudioServer.set_bus_mute(sfx_bus, not AudioServer.is_bus_mute(sfx_bus))
	if AudioServer.is_bus_mute(sfx_bus):
		sfx_sprite.animation = "sound_off"
	else:
		sfx_sprite.animation = "sound_on"
