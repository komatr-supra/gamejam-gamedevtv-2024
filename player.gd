extends RigidBody2D

@export var rotation_speed = 2000
@export var thrust_power = 500
@export var max_linear_speed = 500
@export var max_rotation_angle = PI / 4
@export var power:float = 100
@export var thrust_cost:float = 0.1
@export var collision_cost:int = 15
func _ready():
	$"../TextureProgressBar".value = power
func _integrate_forces(state):
	var thrust_enabled = false
	
	if Input.is_action_pressed("left"):
		
		apply_torque_impulse(-rotation_speed * state.step)
		
	elif Input.is_action_pressed("right"):
		
		apply_torque_impulse(rotation_speed * state.step)
	if linear_velocity.length() > max_linear_speed:
		linear_velocity = linear_velocity.normalized() * max_linear_speed
	
	if Input.is_action_pressed("thrust"):
		var thrust = Vector2(0, -thrust_power).rotated(rotation)
		apply_central_impulse(thrust * state.step)
		power = power - thrust_cost		
		$"../TextureProgressBar".value = power
		thrust_enabled = true
	get_node("jet").thrust(thrust_enabled)



func _on_body_entered(body):
	print("collision")


func _on_area_2d_body_entered(body):	
	power -= collision_cost
	var point = body.particles_create()	
	if power <= 0:
		queue_free()
