extends Node2D

#called when the player reaches the end
signal reached_end(pieces)

func body_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("Players"):
		transfer_pieces(body)
		
func transfer_pieces(player):
	var piece_controller = player.get_node("PieceController")
	var pieces_count = piece_controller.attached_pieces.size()

	for piece in piece_controller.attached_pieces:
		piece.is_attached = false

	emit_signal("reached_end", pieces_count)
	print("reached end with ", pieces_count, " pieces")
