extends Node2D

func body_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("player"):
		next_level()

func next_level():
	GlobalScript.current_level += 1
	
	var next_level_path: String = \
	"levels/season_" + str(GlobalScript.current_season) + "/level_" + str(GlobalScript.current_level) + ".tscn"
	
	if ResourceLoader.exists(next_level_path):
		var _a = get_tree().change_scene(next_level_path)
