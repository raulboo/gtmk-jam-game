extends Node
enum PieceType {SLINGSHOT, LEGS, GRAVITY}
onready var piece_controller = $"../PieceController"
onready var player_kinematic = get_parent()
export(float) var rope_momentum = 5

func _input(event):
	#gravity
	if event.is_action_pressed('invert_gravity'):
		if player_kinematic.gravity_current < 0:
			piece_controller.de_attach_piece_enum(PieceType.GRAVITY)
		elif piece_controller.find_piece_boolean(PieceType.GRAVITY) == true:
				invert_gravity()
			
	#rope
	if event.is_action_released("trigger_slingshot") && piece_controller.find_piece_boolean(PieceType.SLINGSHOT):
		use_slingshot()

func on_piece_attached(piece):
	player_kinematic.play_sfx("Click")
	
func on_piece_de_attached(piece):
	player_kinematic.play_sfx("Click")

	match piece.type:
		PieceType.GRAVITY:
			reset_gravity()

func invert_gravity():
	player_kinematic.play_sfx("Gravity")
	player_kinematic.gravity_current *= -1
	player_kinematic.jump_force *= -1
	player_kinematic.up_direction *= -1
	#TODO: make the sprite turn around

func reset_gravity():
	if player_kinematic.gravity_current < 0:
		player_kinematic.gravity_current *= -1
	if player_kinematic.jump_force < 0:
		player_kinematic.jump_force *= -1
	player_kinematic.up_direction = Vector2.UP

func use_slingshot():
	player_kinematic.play_sfx("Slingshot")
	player_kinematic.velocity += ((player_kinematic.get_global_mouse_position() - player_kinematic.global_position).normalized() * rope_momentum)
	player_kinematic.on_rope_momentum = true
	#player_kinematic.velocity.y -= gravity_current
	piece_controller.de_attach_piece_enum(PieceType.SLINGSHOT)
