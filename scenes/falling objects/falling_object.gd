extends RigidBody2D

@export var particles : PackedScene
@export var meteorites: Array[Texture2D] = []

var speed_increase = 0

func _ready():
	if meteorites.size() > 0:
		$Sprite2D.texture = meteorites[randi() % meteorites.size()]
	
	var x = randf_range(0.1, 0.25)
	var y = randf_range(0.1, 0.25)
	var size = Vector2(x, y)
	mass = (x+y) * 0.5
	linear_velocity = Vector2(0, randf_range(0, 100) + (50/mass) + speed_increase)
	$CollisionShape2D.scale = size
	$Sprite2D.scale = size

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
		print("creating particle")
		particles_create()

func _on_area_entered(area):
	if area.is_in_group("delete_object"):
		self.queue_free()
