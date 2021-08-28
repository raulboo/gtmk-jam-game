extends Node
var power_ups_array = []
var player_attacher = null

func restore_all_pieces(enable_pieces: bool) -> void:
	if player_attacher == null:
		return
		
	player_attacher.de_attach_all_pieces()
	_set_enabled_all_pieces(enable_pieces)

func _set_enabled_all_pieces(value: bool) -> void:
	for p in power_ups_array:
		p.set_enabled(value)
