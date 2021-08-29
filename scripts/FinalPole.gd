extends Node2D

export(PackedScene) var next_level_scene

func body_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("player"):
		next_level()

func next_level():
	if next_level_scene != null:
		var _a = get_tree().change_scene_to(next_level_scene)
