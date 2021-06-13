class_name Level
extends Node2D

signal next_level_key_pressed

export(int) var pieces_needed_to_win = 1
export(PackedScene) var next_level 
export(MusicManager.Loops) var music_loop = 1

onready var original_player_position = $Player.position

func _ready():
	$Player.connect("player_dead", self, "on_player_dead")
	MusicManager.switch_loop(music_loop)
	$LevelCompleteLayer/Window.hide()

func _physics_process(_delta):
	if Input.is_action_just_pressed("next_level"):
		emit_signal("next_level_key_pressed")


func on_player_dead():
	$Player.position = original_player_position

func _on_FinalPole_reached_end(pieces):
	print("reached end with ", pieces, " pieces")
	if pieces >= pieces_needed_to_win:
		$SFX/Victory.play()
		$LevelCompleteLayer/Window.show()
		# Display animation or followup to the next level
		yield(self, "next_level_key_pressed")
		
		get_tree().call_deferred("change_scene_to", next_level)
		print("moving to next level")
		
	else:
		$FinalPole.get_node("NopeSFX").play()
		$FinalPole.get_node("NopeLabel").text = "Needs %s pieces" % pieces_needed_to_win
