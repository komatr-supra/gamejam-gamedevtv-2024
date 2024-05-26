extends Control

func _ready():
	$".".hide()
func game_over():
	show()
	$Label2.text = str(SystemData.time)
