extends Node

onready var player_node = $"../"
onready var sound_player = $"../SoundPlayer"

var spawn_position = Vector2.ZERO
var can_die: bool = true

func _ready():
	spawn_position = player_node.position
	GlobalScript.setup(player_node)
	PowerUpInterface.setup(player_node.get_node("PowerUpAttacher"))

func _physics_process(_delta):
	_check_hostile_collisions()

	if Input.is_action_just_pressed("reset_level"):
		_die("click")

func reset():
	player_node.position = spawn_position
	PowerUpInterface.restore_all_pieces(true)

func _check_hostile_collisions():
	for slide_index in player_node.get_slide_count():
		var object = player_node.get_slide_collision(slide_index).collider
		if object.is_in_group("hostile"):
			if can_die == true:
				_die("death")

func _die(sound):
	sound_player.play_sfx(sound)
	reset()
