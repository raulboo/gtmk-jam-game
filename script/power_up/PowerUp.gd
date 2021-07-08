extends Node2D

export(GlobalScript.PieceType) var type

onready var player_piece_controller = get_node("/root/Level/Player/PowerUpAttacher")

var prefer_slot = 1
var spawn_position
var attached_slot = -1

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

			#destroys the piece
func destroy():
	queue_free()

#orientates the sprite accordingly
func set_piece_position(position, slot_index):
	$Sprite.rotation_degrees = -90 + (slot_index * 90) 
	self.position = position

#change global position of this piece, useful later for animation
func move_to (pos):
	self.global_position = pos

func set_attached(index):
	attached_slot = index

#change this piece parent
func change_parent(parent_node):
	self.get_parent().remove_child(self)
	parent_node.add_child(self)

func on_body_entered(body):
	if body.is_in_group("player") && attached_slot == -1:
		player_piece_controller.call_deferred("attach_piece", self)
