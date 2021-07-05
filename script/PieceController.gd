extends Node

signal piece_attached(type_string)
signal piece_de_attached(type_string)

const MAX_PIECES = 3

export(float) var sprite_piece_size = 32

var slot_array = []
onready var player = get_parent()
onready var game_scene = get_node("/root/Level") #TODO: keep an eye on this

class Slot:
	var position
	var piece
	var collider

func _ready():
	create_slots($PieceCenter.position)

#hard code slots relative to the player
func create_slots(piece_spawn):
	var left = Slot.new()
	left.position = Vector2(piece_spawn.x - sprite_piece_size, piece_spawn.y)
	left.piece = null
	left.collider = $"../LeftCollider"

	var up = Slot.new()
	up.position = Vector2(piece_spawn.x, piece_spawn.y - sprite_piece_size)
	up.piece = null
	up.collider = $"../UpCollider"

	var right = Slot.new()
	right.position = Vector2(piece_spawn.x + sprite_piece_size, piece_spawn.y)
	right.piece = null
	right.collider = $"../RightCollider"

	slot_array = [left, up, right]

#add a new piece to the player
func attach_piece(piece):
	if slot_array.size() > MAX_PIECES:
		return

	var slot_index = get_avaiable_slot(piece)
	if slot_index == -1:
		return

	if find_piece_boolean(piece.type) == false:
		piece.change_parent(player.get_node("PieceHolder"))
		piece.set_piece_position(slot_array[slot_index].position, slot_index)
		piece.set_attached(slot_index)
		slot_array[slot_index].piece = piece
		slot_array[slot_index].collider.disabled = false
		emit_signal("piece_attached", piece)
	
#removes the selected piece
func de_attach_piece(piece):
	if find_piece_boolean(piece.type) == true:
		slot_array[piece.attached_slot].collider.disabled = true
		slot_array[piece.attached_slot].piece = null
		piece.change_parent(game_scene)
		piece.set_de_attached()		
		piece.move_to_spawn()	
		emit_signal("piece_de_attached", piece)

#returns the index of an available slot, if there are no slots available it returns -1
func get_avaiable_slot(piece):
	if find_piece_boolean(piece.type) == false && !has_piece_at(piece.prefer_slot):
		return piece.prefer_slot
	
	for i in MAX_PIECES:
		if slot_array[i].piece == null:
			return i
	
	return -1

func de_attach_piece_enum(piece_type_enum):
	var piece = find_piece(piece_type_enum)
	if piece != null:
		de_attach_piece(piece)

func de_attach_all_pieces():
	for slot in slot_array:
		if slot.piece != null:
			de_attach_piece(slot.piece)
	
func find_piece(piece_type_enum):
	for slot in slot_array:
		if slot.piece != null && slot.piece.type == piece_type_enum:
			return slot.piece
	return null

func find_piece_boolean(piece_type_enum):
	return find_piece(piece_type_enum) != null

func has_piece_at(slot):
	if slot < MAX_PIECES:
		return slot_array[slot].piece != null
	return false

func piece_count():
	var count = 0
	for slot in slot_array:
		if slot.piece != null:
			count += 1
	return count