extends Node

onready var piece_controller = $"../PieceController"
onready var player_kinematic = get_parent()

var powerup_states = {
	"LEGS": false,
	"GRAVITY": false,
	"ROPE": false,
}

func _input(event):
	if event.is_action_pressed('invert_gravity'):
		#gravity
		if player_kinematic.gravity_current < 0:
			piece_controller.de_attach_piece_string("GRAVITY")
		if powerup_states["GRAVITY"]:
			invert_gravity()
			
	if event.is_action_released("trigger_rope") and powerup_states["ROPE"]:
		player_kinematic.velocity += ((
					player_kinematic.get_global_mouse_position() 
					- player_kinematic.global_position
					) * 5)
		player_kinematic.on_rope_momentum = true
		#player_kinematic.velocity.y -= gravity_current
		piece_controller.de_attach_piece_string("ROPE")



func on_piece_attached(type_string):
	powerup_states[type_string] = true
	
	match type_string:
		"LEGS":
			player_kinematic.get_node("FrontCollision").disabled = false
		"GRAVITY":
			player_kinematic.get_node("UpperCollision").disabled = true
		"ROPE":
			player_kinematic.get_node("UpperCollision").disabled = false

func on_piece_de_attached(type_string):
	powerup_states[type_string] = false
	
	match type_string:
		"LEGS":
			player_kinematic.get_node("FrontCollision").disabled = true
		
		"GRAVITY":
			reset_gravity()
			
		"ROPE":
			player_kinematic.get_node("UpperCollision").disabled = true

func invert_gravity():
	player_kinematic.gravity_current *= -1
	player_kinematic.jump_force *= -1
	player_kinematic.up_direction *= -1
	#TODO: make the sprite turn around

func reset_gravity():
	player_kinematic.get_node("UpperCollision").disabled = true
	if player_kinematic.gravity_current < 0:
		player_kinematic.gravity_current *= -1
	if player_kinematic.jump_force < 0:
		player_kinematic.jump_force *= -1
	player_kinematic.up_direction = Vector2.UP