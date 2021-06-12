extends Node2D

onready var original_player_position = $Player.position

func _on_Player_dead():
	$Player.position = original_player_position


func _on_Piece_dropped(type):
	for piece in get_tree().get_nodes_in_group("jigsaw_piece"):
		if piece.type == type:
			piece.respawn()
