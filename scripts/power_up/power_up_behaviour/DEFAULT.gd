extends Node

var player_movement = GlobalScript.player_main_node.get_node("PlayerMovement")
var sound_player = GlobalScript.player_main_node.get_node("SoundPlayer")
var player_attacher = GlobalScript.player_main_node.get_node("PowerUpAttacher")

var _enabled: bool = false

func attached():
	_enabled = true
	sound_player.play_sfx("click")

func de_attached():
	_enabled = false
	sound_player.play_sfx("click")