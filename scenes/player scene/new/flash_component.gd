extends Node

@export var player: CanvasItem
@export var duration: float = 0.1

const flash_resource = preload("res://scenes/player scene/new/flash.tres")

var player_sprite_material: Material
var timer: Timer = Timer.new()

func _ready() -> void:
	player_sprite_material = player.material
	add_child(timer)

func flash() -> void:
	player.material = flash_resource
	timer.start(duration)
	await timer.timeout
	player.material = player_sprite_material
