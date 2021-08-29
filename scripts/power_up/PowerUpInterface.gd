extends Node
var power_ups_array = []

var _player_attacher = null

func setup(attacher):
	_player_attacher = attacher
	
	var _a = _player_attacher.connect("attached", self, "on_piece_attached")
	var _b = _player_attacher.connect("de_attached", self, "on_piece_de_attached")

func restore_all_pieces(enable_pieces: bool) -> void:
	if _player_attacher == null:
		return
		
	_player_attacher.de_attach_all_pieces()
	_set_enabled_all_pieces(enable_pieces)

func _set_enabled_all_pieces(value: bool) -> void:
	for p in power_ups_array:
		p.set_enabled(value)
		
func on_piece_attached(_piece):
	pass
	
func on_piece_de_attached(_piece, slot):
	if slot == 2: #the slot where the pieces should be
		var legs = _player_attacher.get_piece(GlobalScript.PieceType.LEGS)
		
		if legs != null:
			_player_attacher.switch_slots(legs.attached_slot, 2)
