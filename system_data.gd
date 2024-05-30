extends Node

var max_time = 180
var time_left = 180
var time_survived = 0
var time_outside_screen = 10

var player_max_fuel: float = 100
var player_fuel: float = 100

var collision_cost: int = 1

var player_max_health: int = 15
var player_health: int = 15

var shield_max_health: int = 1
var shield_health: int = 1
var shield_cooldown: int = 10

var health_collected: int = 0
var fuel_collected: int = 0
