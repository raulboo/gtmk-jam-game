extends Node2D

export(MusicManager.Loops) var music_loop = 1

func _ready():
	load_pieces()
	
	var random_track: int = MusicManager.Loops.values()[randi()%MusicManager.Loops.size()]
	MusicManager.switch_loop(random_track)

func load_pieces():
	PowerUpInterface.power_ups_array.clear()
	
	for node in get_children():
		if node.is_in_group("power_up"):
			PowerUpInterface.power_ups_array.append(node)
