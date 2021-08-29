extends Node

var player_movement = GlobalScript.player_main_node.get_node("PlayerMovement")
var sound_player = GlobalScript.player_main_node.get_node("SoundPlayer")
var player_attacher = GlobalScript.player_main_node.get_node("PowerUpAttacher")

const ROPE_MOMENTUM = 1500
const ANGLE = 60

var _enabled: bool = false

func _init():
	set_process_input(true)

func attached():
	_enabled = true
	sound_player.play_sfx("click")

func de_attached():
	_enabled = false
	sound_player.play_sfx("click")

func _input(event):
	if _enabled == false:
		return

	if event.is_action_pressed("shift"):
		use_slingshot()

func use_slingshot():
	sound_player.play_sfx("slingshot")

	var degrees = deg2rad(ANGLE)
	player_movement.velocity = Vector2(cos(degrees) * player_movement.facing_direction, \
										sin(-degrees) * player_movement.gravity_direction) * ROPE_MOMENTUM

	player_attacher.de_attach_piece(get_parent())
