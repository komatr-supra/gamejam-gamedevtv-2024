extends Node

@onready var main_label = $MarginContainer/GridContainer/TopMarginContainer/MainLabel
@onready var footer_label = $MarginContainer/GridContainer/FooterMarginContainer/FooterLabel
@onready var audio_typing: AudioStreamPlayer = $AudioTyping

var footer_label_visible = true

func _ready():
	var text_tween = get_tree().create_tween()
	text_tween.tween_property(main_label, "visible_ratio", 1, 10.8)
	audio_typing.play()
	await text_tween.finished
	audio_typing.stop()
	footer_label.text = "Press SPACEBAR to start"

func _process(delta: float) -> void:
	if audio_typing.get_playback_position() > 2.7:
		audio_typing.play()

func _on_timer_timeout():
	var blink_tween = get_tree().create_tween()
	if footer_label_visible:
		blink_tween.tween_property(footer_label, "modulate", Color.TRANSPARENT, 0.5)
		await blink_tween.finished
		footer_label_visible = false
		$Timer.start(0.5)
	else:
		blink_tween.tween_property(footer_label, "modulate", Color.WHITE, 0.5)
		await blink_tween.finished
		footer_label_visible = true
		$Timer.start(0.5)

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		audio_typing.stop()
		get_tree().change_scene_to_file("res://scenes/main game scene/game_scene.tscn")
