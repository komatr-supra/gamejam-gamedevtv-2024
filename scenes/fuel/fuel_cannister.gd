extends Area2D
#
#func _ready():
	#get_parent().fuel_exists = true

func _process(delta):
	position.y += 1

func _on_area_entered(area):
	if area.is_in_group("player"):
		if SystemData.player_fuel <= 75:
			SystemData.player_fuel += 25
		else:
			SystemData.player_fuel = 100
		get_parent().fuel_timer.start(5)
		self.queue_free()

	if area.is_in_group("delete_object"):
		get_parent().fuel_timer.start(5)
		self.queue_free()
