extends AudioStreamPlayer

enum Loops {MENU, GP1, GP2}

export(AudioStream) var menu_stream
export(AudioStream) var gp1_stream
export(AudioStream) var gp2_stream

func _ready():
	switch_loop(Loops.MENU)	
	
func switch_loop(new_loop):
	match new_loop:
		Loops.MENU:
			self.stream = menu_stream
		Loops.GP1:
			self.stream = gp1_stream
		Loops.GP2:
			self.stream = gp2_stream
	self.play()

func mute():
	self.stop()