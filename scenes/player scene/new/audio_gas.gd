extends AudioStreamPlayer

var thrusting: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if thrusting and playing and get_playback_position() > 2.0:
		play(1.0)


func _on_player_thrust_started() -> void:
	if SystemData.player_fuel > 0:
		thrusting = true
		play()


func _on_player_thrust_ended() -> void:
#	if thrusting:
		thrusting = false
		if playing:
			play(2.34)


func _on_player_player_death_signal() -> void:
	stop()
