extends Node2D

onready var original_player_position = $Player.position

func _on_Player_dead():
	$Player.position = original_player_position
