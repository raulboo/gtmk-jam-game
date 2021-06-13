extends Node

onready var piece_controller = $"../PieceController"
onready var player_kinematic = get_parent()
export(float) var rope_momentum = 5

#colliders
onready var upper_collider = $"../UpperCollision"
onready var front_collider = $"../FrontCollision"
onready var back_collider = $"../BackCollision"

var powerup_states = {
	"LEGS": false,
	"GRAVITY": false,
	"ROPE": false,
}

func _input(event):
	#gravity
	if event.is_action_pressed('invert_gravity'):
		if player_kinematic.gravity_current < 0:
			piece_controller.de_attach_piece_string("GRAVITY")
		else:
			if powerup_states["GRAVITY"] == true:
				invert_gravity()
			
	#rope
	if event.is_action_released("trigger_rope") and powerup_states["ROPE"] == true:
		use_rope()

func on_piece_attached(type_string):
	powerup_states[type_string] = true

	#------------------------------------------------------------------------------------
	#if the attached powerup is the leg one, we want to it always
	#be on the right (just a looking thing), so we swap it

	#if type_string == "LEGS":
	#	piece_controller.swap("LEGS", 1)
	#------------------------------------------------------------------------------------

	if piece_controller.slot_dict[piece_controller.UP_SLOT][1] == true:
		upper_collider.disabled = false

	match type_string:
		"LEGS":
			front_collider.disabled = false
		"ROPE":
			upper_collider.disabled = false #TODO: ask why?

func on_piece_de_attached(type_string):
	powerup_states[type_string] = false
	
	match type_string:
		"LEGS":
			front_collider.disabled = true
		
		"GRAVITY":
			reset_gravity()
			
		"ROPE":
			upper_collider.disabled = true

func invert_gravity():
	player_kinematic.gravity_current *= -1
	player_kinematic.jump_force *= -1
	player_kinematic.up_direction *= -1
	#TODO: make the sprite turn around

func reset_gravity():
	upper_collider.disabled = true
	if player_kinematic.gravity_current < 0:
		player_kinematic.gravity_current *= -1
	if player_kinematic.jump_force < 0:
		player_kinematic.jump_force *= -1
	player_kinematic.up_direction = Vector2.UP

func use_rope():
	player_kinematic.velocity += ((
		player_kinematic.get_global_mouse_position() 
		- player_kinematic.global_position
		) * rope_momentum)
	player_kinematic.on_rope_momentum = true
	#player_kinematic.velocity.y -= gravity_current
	piece_controller.de_attach_piece_string("ROPE")
