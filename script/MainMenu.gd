extends MarginContainer

export(PackedScene) var first_level

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		var _scene = get_tree().change_scene_to(first_level)
