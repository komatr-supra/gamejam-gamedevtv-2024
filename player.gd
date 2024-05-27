extends RigidBody2D

@export var rotation_speed = 10
@export var max_rotation_speed = PI / 4  # Maximální rychlost rotace v radiánech za sekundu

@export var thrust_power = 500
@export var max_linear_speed = 500
@export var power: float = 100
@export var thrust_cost: float = 0.1
@export var collision_cost: int = 15
@export var death_particles: PackedScene

@onready var power_bar : TextureProgressBar = $PowerBar

signal player_data_signal(velocity: Vector2, position: Vector2)

func _ready():
	$"../TextureProgressBar".value = power
	power_bar.value = power

func _integrate_forces(state):
	var thrust_enabled = false
	var current_angular_velocity = angular_velocity  # Aktuální úhlová rychlost
	
	# Ovládání rotace
	if Input.is_action_pressed("left"):
		if current_angular_velocity > -max_rotation_speed:
			apply_torque_impulse(-rotation_speed * state.step)
	elif Input.is_action_pressed("right"):
		if current_angular_velocity < max_rotation_speed:
			apply_torque_impulse(rotation_speed * state.step)
	
	# Omezení lineární rychlosti
	if linear_velocity.length() > max_linear_speed:
		linear_velocity = linear_velocity.normalized() * max_linear_speed

	# Aktivace a kontrola thrustu
	if Input.is_action_pressed("thrust"):
		var thrust = Vector2(0, -thrust_power).rotated(rotation)
		apply_central_impulse(thrust * state.step)
		power -= thrust_cost
		$"../TextureProgressBar".value = power
		power_bar.value = power
		if power <= 0:
			player_die()
			thrust_enabled = false
		else:
			thrust_enabled = true
	get_node("jet").thrust(thrust_enabled)

	player_data_signal.emit(linear_velocity, global_position)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_die()

func _on_area_2d_body_entered(body):    
	power -= collision_cost
	$"../TextureProgressBar".value = power
	power_bar.value = power
	if power <= 0:
		player_die()

func player_die():
	var particles = $GPUParticles2D
	particles.emitting = true;
	remove_child(particles);
	particles.position = position
	get_parent().add_child(particles)
	queue_free()
