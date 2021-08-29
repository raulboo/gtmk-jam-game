extends Node2D

export(GlobalScript.PieceType) var type

var enabled:bool = true
var prefer_slot:int = 1
var attached_slot:int = -1
var spawn_position:Vector2 = Vector2.ZERO

var _beahviour_script_loaded: bool = false

onready var timer = $Timer
onready var sprite = $Sprite
onready var label = $Label
onready var behaviour_script_node = $BehaviourScript

func _ready():
	var name: String = GlobalScript.PieceType.keys()[type]

	#load behaviour script
	var path: String = "scripts/power_up/power_up_behaviour/"+name+".gd"
	if ResourceLoader.exists(path):
		behaviour_script_node.set_script(load(path))
	else:
		behaviour_script_node.set_script(load("scripts/power_up/power_up_behaviour/DEFAULT.gd"))

	if behaviour_script_node.get_script() != null:
		_beahviour_script_loaded = true

	#load texture
	sprite.play(name)

	#define positions
	_hardcode_positions()
	spawn_position = transform.origin

	#adds itself to the powerup interface array
	PowerUpInterface.power_ups_array.append(self)

func _process(_delta):
	if timer.time_left > 0.01:
		label.text = str(stepify(timer.time_left, 1))
		var r = (timer.time_left / timer.wait_time)
		sprite.modulate.a = r
		
#attaches and configures the piece
func attach(parent, position, index):
	_change_parent(parent)
	_move_to(position)
	_set_piece_rotation(index)
	attached_slot = index

#resets the piece
func reset():
	_change_parent($"/root/Level")
	self.rotation_degrees = 0
	_move_to(spawn_position)
	attached_slot = -1

func set_enabled(value):
	if value == false:
		enabled = false
		self.visible = false
	else:
		enabled = true
		self.visible = true

#when called a timer will start and the piece will be automaticlly de_attached on `seconds`
func destroy_in(seconds):
	label.visible = true
	timer.start(seconds)

#stops the destroy timer
func reset_timer():
	timer.stop()
	label.visible = false
	sprite.modulate.a = 1
	if attached_slot != -1:
		var pu_attacher = get_node("../../PowerUpAttacher")
		pu_attacher.de_attach_piece(self)

#calls the attached() function on the behaviour script
func call_attached():
	if _beahviour_script_loaded == true:
		behaviour_script_node.attached()

#calls the de_attached() function on the behaviour script
func call_de_attached():
	if _beahviour_script_loaded == true:
		behaviour_script_node.de_attached()

#preferable positions for the power-up
func _hardcode_positions():
	match type:
		#back:0 up:1 front:2
		GlobalScript.PieceType.SLINGSHOT:
			prefer_slot = 1
		GlobalScript.PieceType.LEGS:
			prefer_slot = 2
		GlobalScript.PieceType.GRAVITY:
			prefer_slot = 1

#orientates the sprite accordingly
func _set_piece_rotation(slot_index):
	self.rotation_degrees = -90 + (slot_index * 90) 

#change global position of this piece, useful later for animation
func _move_to (pos):
	self.position = pos

#change this piece parent
func _change_parent(parent_node):
	self.get_parent().remove_child(self)
	parent_node.add_child(self)

#callbacks
func timer_timeout():
	reset_timer()

func on_body_entered(body):
	if body.is_in_group("player") && attached_slot == -1:
		var player_piece_controller = body.get_node("PowerUpAttacher")
		player_piece_controller.call_deferred("attach_piece", self)
