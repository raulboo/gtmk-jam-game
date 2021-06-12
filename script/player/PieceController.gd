extends Node

#max amount of pieces allowed
const MAX_PIECES = 3

onready var player = get_parent()
onready var game_scene = get_node("/root/Level") #TODO: CHANGE THIS!
var attached_pieces = [] #current player pieces are stored here
var slot_dict = {}

signal piece_attached(type)
signal piece_de_attached(type)

func _ready():
	var piece_spawn = $PieceCenter.position
	#hard code slots relative to the player
	slot_dict = {
		0: [Vector2(piece_spawn.x + 40, piece_spawn.y), false],
		1: [Vector2(piece_spawn.x, piece_spawn.y - 40), false],
		2: [Vector2(piece_spawn.x - 40, piece_spawn.y), false]
	}
	
#add a new piece to the player
func attach_piece(piece):
	var pieces_amount = attached_pieces.size()
	if pieces_amount < MAX_PIECES && find_piece(piece) == false:
		piece.change_parent(player)
		
		var slot_index = get_avaiable_slot()
		piece.set_piece_position_based_on_amount(slot_dict[slot_index][0], pieces_amount)
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
		attached_pieces.erase(piece) 
		emit_signal("piece_de_attached", piece.power_type)	

func get_avaiable_slot():
	for i in slot_dict.size():
		if slot_dict[i][1] == false:
			return i
			
func find_piece(piece):
	for a in attached_pieces:
		if a.power_type == piece.power_type:
			return true
	return false
