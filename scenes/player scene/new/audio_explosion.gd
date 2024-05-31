extends AudioStreamPlayer


func _on_player_player_death_signal() -> void:
	play()
	await finished
