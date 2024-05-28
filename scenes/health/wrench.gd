extends Area2D

func _process(delta):
	position.y += 3

func _on_area_entered(area):
	if area.is_in_group("player"):
		if SystemData.player_health <= 8:
			SystemData.player_health += 2
		else:
			SystemData.player_health = 10
		get_parent().health_timer.start(3)
		self.queue_free()

	if area.is_in_group("delete_object"):
		get_parent().health_timer.start(3)
		self.queue_free()
