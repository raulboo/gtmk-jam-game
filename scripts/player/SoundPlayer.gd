extends AudioStreamPlayer

export(AudioStream) var click
export(AudioStream) var jump
export(AudioStream) var death
export(AudioStream) var gravity
export(AudioStream) var walking
export(AudioStream) var slingshot

func play_sfx(sound: String):
	var stream = get(sound)
	if stream != null:
		if self.playing:
			var new_sfx_player = self.duplicate()
			add_child(new_sfx_player)
			new_sfx_player.stream = stream
			new_sfx_player.play()
			yield(new_sfx_player, "finished")
			new_sfx_player.queue_free()
		else:
			self.stream = stream
			self.play()
	else:
		print("couldnt find audio stream:", sound)
