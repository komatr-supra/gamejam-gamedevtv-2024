extends Area2D

#func _ready():
	#if get_parent().fuel_timer.time_left <= 0:
		#get_parent().fuel_timer.start(5)

func _process(delta):
	position.y += 200 * delta

func _on_area_entered(area):
	if area.is_in_group("player"):
		if SystemData.player_fuel <= 75:
			SystemData.player_fuel += 25
		else:
			SystemData.player_fuel = SystemData.player_max_fuel
		get_parent().fuel_timer.start(5)
		SystemData.fuel_collected += 1
		self.queue_free()

	if area.is_in_group("delete_object"):
		get_parent().fuel_timer.start(5)
		self.queue_free()
