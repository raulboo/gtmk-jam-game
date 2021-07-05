extends Node

signal player_dead()

onready var kinematic_body = $"../"
onready var sound_player = $"../SoundPlayer"

func _physics_process(_delta):
	check_hostile_collisions()

#iterates player collisions and checks for any "hostile"
func check_hostile_collisions():
	for slide_index in kinematic_body.get_slide_count():
		var object = kinematic_body.get_slide_collision(slide_index).collider
		if object.is_in_group("hostile"):
			die()

func die():
	sound_player.play_sfx("death")
	$"../PieceController".de_attach_all_pieces()
	$"../PowerUpManager".reset_gravity()
	emit_signal("player_dead")
