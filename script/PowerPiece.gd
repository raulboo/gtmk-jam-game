extends Node2D
class_name PowerPiece

enum PieceType {SLINGSHOT, LEGS, GRAVITY}
enum SlotsEnum {LEFT, UP, RIGHT}

export(PieceType) var type

var prefer_slot
var spawn_position
var attached_slot = -1

func _ready():
	$Sprite.play(PieceType.keys()[type])
	spawn_position = self.global_position
	hardcode_positions()

#preferable positions for the power-up
func hardcode_positions():
	match type:
		PieceType.SLINGSHOT:
			prefer_slot = SlotsEnum.UP
		PieceType.LEGS:
			prefer_slot = SlotsEnum.RIGHT
		PieceType.GRAVITY:
			prefer_slot = SlotsEnum.UP

#change this piece parent (probably call with deffer_call)
func change_parent(parent_node):
	self.get_parent().remove_child(self)
	parent_node.add_child(self)
	
#orientates the sprite accordingly
func set_piece_position(position, slot_index):
	$Sprite.rotation_degrees = -90 + (slot_index * 90) 
	self.position = position

#change global position of this piece
func move_to (pos):
	self.global_position = pos

#return piece to spawn, useful later for animation
func move_to_spawn ():
	self.global_position = spawn_position
	
func set_attached(index):
	attached_slot = index
	
func set_de_attached():
	attached_slot = -1

#TODO: watch this
onready var player_piece_controller = get_node("/root/Level/Player/PieceController")
func on_body_entered(body):
	if body.is_in_group("player") && attached_slot == -1:
		player_piece_controller.call_deferred("attach_piece", self)
