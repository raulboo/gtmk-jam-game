extends Node

var player_movement = GlobalScript.player_main_node.get_node("PlayerMovement")
var sound_player = GlobalScript.player_main_node.get_node("SoundPlayer")

var _enabled: bool = false

const SPEED_UP_PIECE_MULTIPLIER = 1.6
const SPEED_UP_PIECE_TIMEOUT = 4

func attached():
	_enabled = true
	sound_player.play_sfx("click")
	get_parent().destroy_in(SPEED_UP_PIECE_TIMEOUT)
	player_movement.speed_multiplier = SPEED_UP_PIECE_MULTIPLIER

func de_attached():
	_enabled = false
	sound_player.play_sfx("click")
	player_movement.speed_multiplier = 1
