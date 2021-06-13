extends Node

#max amount of pieces allowed
const MAX_PIECES = 3

onready var player = get_parent()
onready var game_scene = get_node("/root/Level") #TODO: keep an eye on this
export(float) var sprite_piece_size = 32

var attached_pieces = [] #current player pieces are stored here
var slot_dict = {} #hard coded piece positions are stored inside

signal piece_attached(type_string)
signal piece_de_attached(type_string)

func _ready():
	var piece_spawn = $PieceCenter.position
	#hard code slots relative to the player
	slot_dict = {
		0: [Vector2(piece_spawn.x + sprite_piece_size, piece_spawn.y), false],
		1: [Vector2(piece_spawn.x, piece_spawn.y - sprite_piece_size), false],
		2: [Vector2(piece_spawn.x - sprite_piece_size, piece_spawn.y), false]
	}
	
#add a new piece to the player
func attach_piece(piece):
	var pieces_amount = attached_pieces.size()
	if pieces_amount < MAX_PIECES && find_piece(piece) == false:
		piece.change_parent(player.get_node("PieceHolder"))
		
		var slot_index = get_avaiable_slot()
		piece.set_piece_position(slot_dict[slot_index][0])
		slot_dict[slot_index][1] = true
		piece.set_attached(slot_index)
		
		attached_pieces.push_back(piece)
		emit_signal("piece_attached", piece.power_type)
		
#removes the selected piece
func de_attach_piece(piece):
	if attached_pieces.find(piece) != -1:
		slot_dict[piece.attached_slot][1] = false
		piece.change_parent(game_scene)
		piece.set_de_attached()		
		piece.move_to_spawn()	
		attached_pieces.erase(piece) 
		emit_signal("piece_de_attached", piece.power_type)	

#search and removes the 'name' piece
func de_attach_piece_string(name: String):
	for piece in attached_pieces:
		if piece.power_type == name:
			de_attach_piece(piece)
			return

func de_attach_and_move(piece, pos):
	de_attach_piece(piece)
	piece.move_to(pos)

#returns the index of an available slot, if there are no slots available it returns -1
func get_avaiable_slot():
	for i in slot_dict.size():
		if slot_dict[i][1] == false:
			return i
	return -1
			
#returns true if piece exists in the current arary
func find_piece(piece):
	for a in attached_pieces:
		if a.power_type == piece.power_type:
			return true
	return false
