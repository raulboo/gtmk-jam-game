class_name Level
extends Node2D

export(int) var pieces_needed_to_win = 1
export(PackedScene) var next_level 
export(MusicManager.Loops) var music_loop = 1

onready var original_player_position = $Player.position

func _ready():
	$Player.connect("player_dead", self, "on_player_dead")
	MusicManager.switch_loop(music_loop)

func on_player_dead():
	$Player.position = original_player_position

func _on_FinalPole_reached_end(pieces):
	print("reached end with ", pieces, " pieces")
	if pieces >= pieces_needed_to_win:
		$SFX/Victory.play()
		
		# Display animation or followup to the next level
		
		
		get_tree().call_deferred("change_scene_to", next_level)
		print("moving to next level")
