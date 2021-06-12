extends StaticBody2D

var is_active : bool = false

func _ready():
	self.hide()
	$CollisionShape2D.disabled = true

func connect_piece():
	is_active = true
	$CollisionShape2D.disabled = false
	self.show()
	
	
func drop():
	is_active = false
	$CollisionShape2D.disabled = true
	self.hide()
