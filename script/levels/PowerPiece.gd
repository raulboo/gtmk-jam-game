extends KinematicBody2D
class_name PowerPiece

enum PieceType {ROPE, LEG, GRAVITY, STICK}
export(PieceType) var enum_type
var power_type
var is_attached = false
var attached_slot = -1
var spawn_position

func _ready():
	power_type = PieceType.keys()[enum_type]
	spawn_position = self.global_position
	
	#TEMPORAL, REMOVE THIS!:	
	var rng = RandomNumberGenerator.new()
	var c: Color
	for i in 3:
		rng.randomize()
		c.r = rng.randf_range(0, 255)
	self.modulate = Color(rng.randf(), rng.randf(), rng.randf(), 1)
	
func change_parent(parent_node):
	self.get_parent().remove_child(self)
	parent_node.add_child(self)
	
#algorithm that should find the place of the new piece
func set_piece_position_based_on_amount(position, _amount):
	var size_y = $BodyCollision.shape.get("extents").y * 2
	#var target = Vector2(position.x, position.y - (size_y * (amount + 1)))
	self.position = position

func set_attached(index):
	is_attached = true
	attached_slot = index
	
func set_de_attached():
	self.global_position = spawn_position
	is_attached = false
	attached_slot = -1
	
#temporal
onready var player_piece_controller = get_node("/root/Level/Player/PieceController")
func on_piece_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('mouse_left'):
		#add piece to the player
		if is_attached == false:
			player_piece_controller.attach_piece(self)
		else:
			player_piece_controller.de_attach_piece(self)
