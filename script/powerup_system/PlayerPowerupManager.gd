extends Node

onready var piece_controller = $"../PieceController"
onready var player_kinematic = get_parent()

var powerup_states = {
	"GRAVITY": false
}

func _input(event):
	if event.is_action_pressed('keyboard_e'):
		#gravity
		if player_kinematic.gravity_current < 0:
			piece_controller.de_attach_piece_string("GRAVITY")
		if powerup_states["GRAVITY"] == true:
			player_kinematic.gravity_current *= -1
			#TODO: make the sprite turn around


func on_piece_attached(type_string):
	if type_string == "GRAVITY":
		powerup_states["GRAVITY"] = true
			

func on_piece_de_attached(type_string):
	if type_string == "GRAVITY":
		if player_kinematic.gravity_current < 0:
			player_kinematic.gravity_current *= -1
		powerup_states["GRAVITY"] = false
