extends Node2D

#called when the player reaches the end
signal reached_end(coins)

func body_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("player"):
		singal_win(body)
		
func singal_win(_player):
	emit_signal("reached_end", 0)