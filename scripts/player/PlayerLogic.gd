extends Node

signal player_dead()

onready var player_node = $"../"
onready var sound_player = $"../SoundPlayer"

var spawn_position = Vector2.ZERO
var can_die: bool = true

func _ready():
	spawn_position = player_node.position
	GlobalScript.player_main_node = player_node

func _physics_process(_delta):
	check_hostile_collisions()

func check_hostile_collisions():
	for slide_index in player_node.get_slide_count():
		var object = player_node.get_slide_collision(slide_index).collider
		if object.is_in_group("hostile"):
			die()

func die():
	if can_die == false:
		return
		
	sound_player.play_sfx("death")
	PowerUpInterface.restore_all_pieces(true)
	#TODO: reset gravity
	emit_signal("player_dead")

func reset():
	player_node.position = spawn_position
