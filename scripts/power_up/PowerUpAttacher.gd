extends Node

signal attached(piece)
signal de_attached(piece, slot)

onready var piece_holder = $"../PieceHolder"

class Slot:
	var position
	var piece
	var collider

var slot_array = []

func _ready():
	_create_slots($PieceCenter.position)

#add a new piece to the player
func attach_piece(piece) -> void:
	if piece.enabled == false:
		return

	var slot_index = _get_avaiable_slot(piece)
	if slot_index == -1:
		return

	if get_piece(piece.type) == null:
		_add_to_slot(slot_index, piece)
		piece.call_attached()
		emit_signal("attached", piece)
	
#removes the selected piece
func de_attach_piece(piece) -> void:
	if get_piece(piece.type) != null:
		var slot = piece.attached_slot
		_remove_from_slot(slot, true)
		piece.call_de_attached()
		emit_signal("de_attached", piece, slot)

#switches two pieces
func switch_slots(from, to) -> void:
	if _has_piece_at(to) || !_has_piece_at(from):
		return

	var piece = slot_array[from].piece
	_remove_from_slot(from, false)
	_add_to_slot(to, piece)

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
	
#hard code slots relative to the player 
func _create_slots(piece_spawn) -> void:
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

func _add_to_slot(slot, piece) -> void:
	slot_array[slot].piece = piece
	slot_array[slot].collider.disabled = false
	piece.attach(piece_holder, slot_array[slot].position, slot)

func _remove_from_slot(slot, reset:bool) -> void:
	var t_piece = slot_array[slot].piece

	slot_array[slot].collider.disabled = true
	slot_array[slot].piece = null

	if t_piece != null && reset:
		t_piece.reset()
		t_piece.set_enabled(false)

#returns the index of an available slot, if there are no slots available it returns -1
func _get_avaiable_slot(piece) -> int:
	if get_piece(piece.type) == null && !_has_piece_at(piece.prefer_slot):
		return piece.prefer_slot
	
	for i in slot_array.size():
		if slot_array[i].piece == null:
			return i
	
	return -1

#returns true if the player has a piece on 'slot'
func _has_piece_at(slot) -> bool:
	if slot < slot_array.size():
		return slot_array[slot].piece != null
	return false
