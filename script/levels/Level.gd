class_name Level
extends Node2D

export(int) var pieces_needed_to_win = 1
export(PackedScene) var next_level 

onready var original_player_position = $Player.position

func _ready():
	$Player.connect("player_dead", self, "on_player_dead")

func on_player_dead():
	$Player.position = original_player_position


func _on_FinalPole_reached_end(pieces : int):
	if pieces == pieces_needed_to_win:
		get_tree().call_deferred("change_scene_to", next_level)
