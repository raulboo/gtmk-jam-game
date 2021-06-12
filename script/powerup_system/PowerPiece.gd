extends Node2D
class_name PowerPiece

enum PieceType {ROPE, LEG, GRAVITY, STICK}
export(PieceType) var enum_type
var power_type
var spawn_position
var is_attached = false
var attached_slot = -1

onready var size = $Area2D/AreaCollision.shape.get("extents") * 2

func _ready():
	power_type = PieceType.keys()[enum_type]
	spawn_position = self.global_position

#change this piece parent (probably call with deffer_call)
func change_parent(parent_node):
	self.get_parent().remove_child(self)
	parent_node.add_child(self)
	
#algorithm that should find the place of the new piece
func set_piece_position(position):
	#var target = Vector2(position.x, position.y - (size_y * (amount + 1)))
	self.position = position

#change global position of this piece
func move_to (pos):
	self.global_position = pos

func move_to_spawn ():
	self.global_position = spawn_position
	
func set_attached(index):
	is_attached = true
	attached_slot = index
	
func set_de_attached():
	is_attached = false
	attached_slot = -1

#temporal
onready var player_piece_controller = get_node("/root/Level/Player/PieceController")
func on_piece_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed('mouse_left'):
		#add piece to the player
		if is_attached == false:
			player_piece_controller.attach_piece(self)
		else:
			player_piece_controller.de_attach_piece(self)
			self.move_to(spawn_position)
