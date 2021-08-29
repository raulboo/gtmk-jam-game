extends Node

var player_movement = GlobalScript.player_main_node.get_node("PlayerMovement")
var sound_player = GlobalScript.player_main_node.get_node("SoundPlayer")
var player_attacher = GlobalScript.player_main_node.get_node("PowerUpAttacher")

var _enabled: bool = false

func _init():
	set_process_input(true)

func attached():
	_enabled = true
	sound_player.play_sfx("click")

func de_attached():
	_enabled = false
	sound_player.play_sfx("click")
	reset_gravity()

func _input(event):
	if _enabled == false:
		return

	if event.is_action_pressed("invert_gravity"):
		if player_movement.current_gravity_force < 0:
			player_attacher.de_attach_piece(get_parent())
		else:
			invert_gravity()

func reset_gravity():
	if player_movement.current_gravity_force < 0:
		player_movement.current_gravity_force *= -1

func invert_gravity():
	sound_player.play_sfx("gravity")
	player_movement.current_gravity_force *= -1