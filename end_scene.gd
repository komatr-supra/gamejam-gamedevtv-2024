extends Control

func _ready():
	$".".hide()
func game_over():
	show()
	$SurvivalTime.text = str(int(SystemData.time))
