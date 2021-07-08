extends Node
enum PieceType {SLINGSHOT, LEGS, GRAVITY}

onready var piece_controller = $"../PieceController"
onready var player_kinematic = $"../"
onready var sound_player = $"../SoundPlayer"

export(float) var rope_momentum = 1000

func _input(event):
	#gravity
	if event.is_action_pressed("invert_gravity") and piece_controller.find_piece_boolean(PieceType.GRAVITY):
		if player_kinematic.gravity_force < 0:
			piece_controller.de_attach_piece_enum(PieceType.GRAVITY)
		else:
			invert_gravity()
			
	#rope
	if event.is_action_pressed("trigger_slingshot") and piece_controller.find_piece_boolean(PieceType.SLINGSHOT):
		use_slingshot()

func on_piece_attached(_piece):
	sound_player.play_sfx("click")
	
func on_piece_de_attached(piece):
	sound_player.play_sfx("click")

	if piece.type == PieceType.GRAVITY:
		reset_gravity()
		
func invert_gravity():
	sound_player.play_sfx("gravity")
	player_kinematic.gravity_force *= -1

func reset_gravity():
	if player_kinematic.gravity_force < 0:
		player_kinematic.gravity_force *= -1

func use_slingshot():
	sound_player.play_sfx("slingshot")

	var degrees = 1.22 #(70 degrees)
	player_kinematic.velocity = Vector2(cos(degrees) * player_kinematic.facing_direction, \
										sin(-degrees) * player_kinematic.gravity_direction) * rope_momentum

	piece_controller.de_attach_piece_enum(PieceType.SLINGSHOT)