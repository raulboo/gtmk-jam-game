extends StaticBody2D

enum Pieces {ROPE, LEG, GRAVITY, STICK}

export(Pieces) var type

onready var velocity : Vector2 
	
func fit_in_character():
	self.hide()
	$CollisionShape2D.disabled = true


func respawn():
	self.show()
	$CollisionShape2D.disabled = false
	


