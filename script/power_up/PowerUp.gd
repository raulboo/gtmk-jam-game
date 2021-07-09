extends Node2D

export(GlobalScript.PieceType) var type

var prefer_slot = 1
var attached_slot = -1
var spawn_position

func _ready():
	$Sprite.play(GlobalScript.PieceType.keys()[type])
	spawn_position = self.global_position
	hardcode_positions()

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
	move_to(spawn_position)
	attached_slot = -1

#orientates the sprite accordingly
func set_piece_rotation(slot_index):
	$Sprite.rotation_degrees = -90 + (slot_index * 90) 

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