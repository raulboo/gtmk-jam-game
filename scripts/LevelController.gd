extends Node2D

export(MusicManager.Loops) var music_loop = 1

func _ready():
	MusicManager.switch_loop(music_loop)
