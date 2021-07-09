extends Node

signal player_dead()

onready var kinematic_body = $"../"
onready var sound_player = $"../SoundPlayer"
onready var coin_displayer = $"../CanvasLayer/HBoxContainer"
onready var power_up_attacher = $"../PowerUpAttacher"
onready var power_up_behaviour = $"../PowerUpBehaviour"

var spawn_position
var coin_count = 0

func _ready():
	spawn_position = kinematic_body.position
	coin_count = 0

func _physics_process(_delta):
	check_hostile_collisions()

func add_coin():
	coin_count += 1
	coin_displayer.add_coin()

func check_hostile_collisions():
	for slide_index in kinematic_body.get_slide_count():
		var object = kinematic_body.get_slide_collision(slide_index).collider
		if object.is_in_group("hostile"):
			die()

func die():
	sound_player.play_sfx("death")
	power_up_attacher.de_attach_all_pieces()
	power_up_behaviour.reset_gravity()
	emit_signal("player_dead")

func reset():
	coin_count = 0
	coin_displayer.reset()
	power_up_attacher.de_attach_all_pieces()
	kinematic_body.position = spawn_position