extends RigidBody2D

@export var particles : PackedScene
#@export var meteorites: Array[Texture2D] = []

@onready var small_asteroid = $SmallAsteroid
@onready var small_asteroid_area = $SmallAsteroid/Area2D/CollisionShape2D
@onready var small_collision_shape = $SmallCollisionShape2D

@onready var medium_asteroid = $MediumAsteroid
@onready var medium_asteroid_area = $MediumAsteroid/Area2D/CollisionShape2D
@onready var medium_collision_shape = $MediumCollisionShape2D

@onready var large_asteroid = $LargeAsteroid
@onready var large_asteroid_area = $LargeAsteroid/Area2D/CollisionShape2D
@onready var large_collision_shape = $LargeCollisionShape2D

@onready var audio_player = $AudioStreamPlayer

var speed_increase = 0
var asteroid_size: int # 0 = SMALL / 1 = MEDIUM / 2 = LARGE
var current_asteroid
var current_collision

signal player_hit_signal

func _ready():
	#if meteorites.size() > 0:
		#$Sprite2D.texture = meteorites[randi() % meteorites.size()]
	
	asteroid_size = randi_range(0, 2)
	
	if asteroid_size == 0:
		small_asteroid.visible = true
		small_asteroid.rotation_degrees = randi_range(0, 180)
		small_collision_shape.rotation_degrees = small_asteroid.rotation_degrees
		small_asteroid_area.disabled = false
		small_collision_shape.disabled = false
		current_asteroid = small_asteroid
		current_collision = small_collision_shape
		mass = randf_range(0.10, 0.15)

	elif asteroid_size == 1:
		medium_asteroid.visible = true
		medium_asteroid.rotation_degrees = randi_range(0, 180)
		medium_collision_shape.rotation_degrees = medium_asteroid.rotation_degrees 
		medium_asteroid_area.disabled = false
		medium_collision_shape.disabled = false
		current_asteroid = medium_asteroid
		current_collision = medium_collision_shape
		mass = randf_range(0.15, 0.2)

	elif asteroid_size == 2:
		large_asteroid.visible = true
		large_asteroid.rotation_degrees = randi_range(0, 180)
		large_collision_shape.rotation_degrees = large_asteroid.rotation_degrees
		large_asteroid_area.disabled = false
		large_collision_shape.disabled = false
		current_asteroid = large_asteroid
		current_collision = large_collision_shape
		mass = randf_range(0.2, 0.25)
	
	#var x = randf_range(0.1, 0.25)
	#var y = randf_range(0.1, 0.25)
	#var size = Vector2(x, y)
	#mass = (x+y) * 0.5
	linear_velocity = Vector2(0, randf_range(0, 100) + (50/mass) + speed_increase)
	#$CollisionShape2D.scale = size
	#$Sprite2D.scale = size

func _process(delta):
	speed_increase += 0.01

func particles_create():
	$particles.restart()
	var new_object = particles.instantiate()
	new_object.position = position
	get_tree().root.add_child(new_object)

func destroy():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_hit_signal.emit()
		particles_create()
		audio_player.playing = true
		current_asteroid.queue_free()
		current_collision.queue_free()
		await audio_player.finished
		self.queue_free()

func _on_area_entered(area):
	if area.is_in_group("delete_object"):
		self.queue_free()

	if area.is_in_group("shield"):
		player_hit_signal.emit()
		particles_create()
		audio_player.playing = true
		current_asteroid.queue_free()
		current_collision.queue_free()
		await audio_player.finished
		self.queue_free()
