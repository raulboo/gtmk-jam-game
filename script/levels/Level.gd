class_name Level
extends Node2D

onready var original_player_position = $Player.position

func _ready():
	$Player.connect("player_dead", self, "on_player_dead")

func on_player_dead():
	$Player.position = original_player_position
