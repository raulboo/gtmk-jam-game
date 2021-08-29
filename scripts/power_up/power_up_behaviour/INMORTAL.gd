extends Node

var player_logic = GlobalScript.player_main_node.get_node("PlayerLogic")
var sound_player = GlobalScript.player_main_node.get_node("SoundPlayer")

var _enabled: bool = false

const IMORTAL_PIECE_TIMEOUT = 10

func attached():
	_enabled = true
	sound_player.play_sfx("click")
	get_parent().destroy_in(IMORTAL_PIECE_TIMEOUT)
	player_logic.can_die = false

func de_attached():
	_enabled = false
	sound_player.play_sfx("click")
	player_logic.can_die = true
