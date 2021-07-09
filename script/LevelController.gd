extends Node2D

signal next_level_key_pressed

export(int) var coins_needed_to_win = 0
export(PackedScene) var next_level 
export(MusicManager.Loops) var music_loop = 1

func _ready():
	$Player/PlayerLogic.connect("player_dead", self, "on_player_dead")
	$Player/WinLabel.visible = false

	MusicManager.switch_loop(music_loop)
	$FinalPole/Label.text = "Needs %s coins!" % coins_needed_to_win

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("next_level_key_pressed")

func on_player_dead():
	$Player/PlayerLogic.reset()

func on_player_reached_final_pole():
	var coins = $Player/PlayerLogic.coin_count

	if coins >= coins_needed_to_win:
		MusicManager.mute()
		$SFX/Victory.play()
		$Player/WinLabel.visible = true

		#display animation or followup to the next level
		yield(self, "next_level_key_pressed")
		
		get_tree().call_deferred("change_scene_to", next_level)
		print("moving to next level")
		return

	$FinalPole/NopeSFX.play()
