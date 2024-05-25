extends RigidBody2D
@export var particles : PackedScene
func _ready():
	linear_velocity = Vector2(0, randf_range(100, 600))
	var size = Vector2(randf_range(0.1, 0.25), randf_range(0.1, 0.25))
	$CollisionShape2D.scale = size
	$Sprite2D.scale = size


func particles_create():
	$particles.restart()
	var new_object = particles.instantiate()
	new_object.position = position
	get_tree().root.add_child(new_object)

func destroy():
	queue_free()
