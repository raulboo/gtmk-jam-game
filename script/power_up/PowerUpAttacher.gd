extends Node

signal piece_attached(type_string)
signal piece_de_attached(type_string, slot)

onready var player = $"../"
onready var piece_holder = $"../PieceHolder"

class Slot:
	var position
	var piece
	var collider

var slot_array = []

func _ready():
	create_slots($PieceCenter.position)

#hard code slots relative to the player 
func create_slots(piece_spawn) -> void:
	var sprite_piece_size = 32

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

func add_to_slot(slot, piece) -> void:
	slot_array[slot].piece = piece
	slot_array[slot].collider.disabled = false

func remove_from_slot(slot) -> void:
	slot_array[slot].collider.disabled = true
	slot_array[slot].piece = null

#add a new piece to the player
func attach_piece(piece) -> void:
	var slot_index = get_avaiable_slot(piece)
	if slot_index == -1:
		return

	if find_piece(piece.type) == false:
		piece.attach(piece_holder, slot_array[slot_index].position, slot_index)
		add_to_slot(slot_index, piece)
		emit_signal("piece_attached", piece)
	
#removes the selected piece
func de_attach_piece(piece) -> void:
	if find_piece(piece.type) == true:
		var slot = piece.attached_slot
		remove_from_slot(slot)
		piece.reset()
		emit_signal("piece_de_attached", piece, slot)

func switch_slots(from, to) -> void:
	if has_piece_at(to) || !has_piece_at(from):
		return

	var piece = slot_array[from].piece

	remove_from_slot(from)

	piece.attach(piece_holder, slot_array[to].position, to)
	add_to_slot(to, piece)

#returns the index of an available slot, if there are no slots available it returns -1
func get_avaiable_slot(piece) -> int:
	if find_piece(piece.type) == false && !has_piece_at(piece.prefer_slot):
		return piece.prefer_slot
	
	for i in slot_array.size():
		if slot_array[i].piece == null:
			return i
	
	return -1

#de attaches the piece (passed as enum)
func de_attach_piece_enum(piece_type_enum) -> void:
	var piece = get_piece(piece_type_enum)
	if piece != null:
		de_attach_piece(piece)

#de attaches all pieces
func de_attach_all_pieces() -> void:
	for slot in slot_array:
		if slot.piece != null:
			de_attach_piece(slot.piece)

#returns the piece if it exists or null otherwise
func get_piece(piece_type_enum) -> Node:
	for slot in slot_array:
		if slot.piece != null && slot.piece.type == piece_type_enum:
			return slot.piece
	return null

#returns true/false if the piece exists
func find_piece(piece_type_enum) -> bool:
	return get_piece(piece_type_enum) != null

#returns true if the player has a piece on 'slot'
func has_piece_at(slot) -> bool:
	if slot < slot_array.size():
		return slot_array[slot].piece != null
	return false
