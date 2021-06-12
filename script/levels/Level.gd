class_name Level
extends Node2D

onready var original_player_position = $Player.position

func _ready():
	$Player.connect("dead", self, "_on_Player_dead")

func _on_Player_dead():
	$Player.position = original_player_position
