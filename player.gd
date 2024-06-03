extends RigidBody2D

@onready var fuel_bar = $FuelBar
@onready var sprite = $AnimatedSprite2D


@export var rotation_speed = 1100
@export var max_rotation_speed = 0.85 # PI / 4 Maximální rychlost rotace v radiánech za sekundu 

@export var thrust_power = 180
@export var max_linear_speed = 145
@export var power: float = 100
@export var thrust_cost: float = 0.05
@export var collision_cost: int = 1
@export var death_particles: PackedScene

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player_area = $PlayerArea
@onready var shield_area = $ShieldArea
@onready var shield_collision = $ShieldArea/CollisionShape2D
@onready var shield_sprite = $ShieldArea/AnimatedSprite2D
@onready var shield_cooldown_timer = $ShieldArea/ShieldCooldown
@onready var audio_gas: AudioStreamPlayer = $AudioGas
@onready var audio_explosion: AudioStreamPlayer = $AudioExplosion
@onready var audio_shield_on: AudioStreamPlayer = $ShieldArea/AudioShieldOn
@onready var audio_shield_off: AudioStreamPlayer = $ShieldArea/AudioShieldOff

var thrust_enabled = false

#@onready var power_bar : TextureProgressBar = $PowerBar

signal player_data_signal(velocity: Vector2, position: Vector2)
signal player_death_signal
signal shield_destroyed_signal
signal thrust_started
signal thrust_ended

func _ready():
	fuel_bar.value = SystemData.player_fuel

func _process(delta):
	if thrust_enabled:
		sprite.animation = "moving"
	else:
		sprite.animation = "idle"

	fuel_bar.value = SystemData.player_fuel

func _integrate_forces(state):
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
		if SystemData.player_fuel > 0:
			apply_central_impulse(thrust * state.step)
			SystemData.player_fuel -= thrust_cost
			thrust_enabled = true
		else:
			thrust_enabled = false
			thrust_ended.emit()
	#get_node("jet").thrust(thrust_enabled)

	if Input.is_action_just_pressed("thrust"):
		thrust_started.emit()

	if Input.is_action_just_released("thrust"):
		thrust_enabled = false
		thrust_ended.emit()

	player_data_signal.emit(linear_velocity, global_position)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_die()
#
#func _on_area_2d_body_entered(body):   
	#if body.is_in_group("asteroid"):
		#SystemData.player_health -= collision_cost
		#if SystemData.player_health <= 0:
			#player_die()

func destroy_shield():
	shield_collision.disabled = true
	shield_sprite.visible = false
	shield_destroyed_signal.emit()
	shield_cooldown_timer.start(SystemData.shield_cooldown)

func _on_shield_cooldown_timeout():
	SystemData.shield_health = SystemData.shield_max_health
	shield_destroyed_signal.emit()
	shield_collision.disabled = false
	shield_sprite.visible = true

func flash():
	print("flash")
	$FlashComponent.flash()

func player_die():
	var particles = $GPUParticles2D
	particles.emitting = true
	remove_child(particles)
	particles.position = position
	get_parent().add_child(particles)
	hide()
	player_death_signal.emit()
	collision_shape.queue_free()
	shield_area.queue_free()
	player_area.queue_free()
	audio_gas.queue_free()
	await audio_explosion.finished
	queue_free()

func _on_player_area_entered(area):
	if area.is_in_group("delete_object"):
		if SystemData.player_fuel <= 0:
			player_die()
