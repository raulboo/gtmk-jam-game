extends Control

export(PackedScene) var first_level

onready var version_label = $Control/VersionLabel

func _ready():
	display_version()

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		var _scene = get_tree().change_scene_to(first_level)

func display_version():
	version_label.text = "ver. " + GlobalScript.game_version
