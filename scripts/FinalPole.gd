extends Node2D

signal reached_end()

func body_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("player"):
		emit_signal("reached_end")
