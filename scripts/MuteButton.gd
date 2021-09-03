extends Button

func _ready():
	determine_color()	

func OnButtonPressed():
	var muted = AudioServer.is_bus_mute(1)
	AudioServer.set_bus_mute(1, !muted)
	
	determine_color()	

func determine_color() -> void:
	if AudioServer.is_bus_mute(1):
		self.modulate = Color(0.9, 0.3, 0.3, 1)
	else:
		self.modulate = Color(1, 1, 1, 1)		
