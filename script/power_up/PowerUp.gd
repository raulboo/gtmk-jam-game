extends Node2D

export(GlobalScript.PieceType) var type

var prefer_slot = 1
var attached_slot = -1
var spawn_position

onready var timer = $Timer
onready var sprite = $Sprite
onready var label = $Label

func _ready():
	sprite.play(GlobalScript.PieceType.keys()[type])
	hardcode_positions()
	spawn_position = transform.origin

func _process(_delta):
	if timer.time_left > 0.01:
		label.text = str(stepify(timer.time_left, 1))
		var r = (timer.time_left / timer.wait_time)
		sprite.modulate.a = r


#preferable positions for the power-up
func hardcode_positions():
	match type:
		#back:0 up:1 front:2
		GlobalScript.PieceType.SLINGSHOT:
			prefer_slot = 1
		GlobalScript.PieceType.LEGS:
			prefer_slot = 2
		GlobalScript.PieceType.GRAVITY:
			prefer_slot = 1

#attaches and configures the piece
func attach(parent, position, index):
	change_parent(parent)
	move_to(position)
	set_piece_rotation(index)
	attached_slot = index

#resets the piece
func reset():
	change_parent($"/root/Level")
	self.rotation_degrees = 0
	move_to(spawn_position)
	attached_slot = -1

#orientates the sprite accordingly
func set_piece_rotation(slot_index):
	self.rotation_degrees = -90 + (slot_index * 90) 

#change global position of this piece, useful later for animation
func move_to (pos):
	self.position = pos

#change this piece parent
func change_parent(parent_node):
	self.get_parent().remove_child(self)
	parent_node.add_child(self)

func on_body_entered(body):
	if body.is_in_group("player") && attached_slot == -1:
		var player_piece_controller = body.get_node("PowerUpAttacher")
		player_piece_controller.call_deferred("attach_piece", self)

func destroy_in(seconds):
	label.visible = true
	timer.start(seconds)

func reset_timer():
	timer.stop()
	label.visible = false
	sprite.modulate.a = 1
	if attached_slot != -1:
		var pu_attacher = get_node("../../PowerUpAttacher")
		pu_attacher.de_attach_piece(self)

func timer_timeout():
	reset_timer()