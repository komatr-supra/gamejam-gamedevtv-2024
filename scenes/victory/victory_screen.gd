extends Control

@onready var left_rich_text_label = $MarginContainer/GridContainer/PickupsGridContainer/LeftRichTextLabel
@onready var right_rich_text_label = $MarginContainer/GridContainer/PickupsGridContainer/RightRichTextLabel

func _ready():
	self.hide()

func game_win():
	left_rich_text_label.bbcode_text = "[center][img=42x68]res://scenes/fuel/NewFuelBarrel.png[/img] " + str(SystemData.fuel_collected) + " COLLECTED[/center]"
	right_rich_text_label.bbcode_text = "[center][img=51x61]res://scenes/health/NewWrench.png[/img] " + str(SystemData.health_collected) + " COLLECTED[/center]"
	self.show()

func _on_try_again_button_up():
	SceneTransition.change_scene_to_file("res://scenes/main game scene/game_scene.tscn")

func _on_menu_button_up():
	SceneTransition.change_scene_to_file("res://scenes/new start scene/menu.tscn")
