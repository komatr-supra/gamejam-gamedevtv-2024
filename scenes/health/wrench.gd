extends Area2D

func _ready():
	if get_parent().health_timer.time_left <= 0:
		get_parent().health_timer.start(3)

func _process(delta):
	position.y += 150 * delta

func _on_area_entered(area):
	if area.is_in_group("player"):
		if SystemData.player_health <= 18:
			SystemData.player_health += 2
		else:
			SystemData.player_health = 20
		get_parent().health_timer.start(3)
		self.queue_free()

	if area.is_in_group("delete_object"):
		get_parent().health_timer.start(3)
		self.queue_free()