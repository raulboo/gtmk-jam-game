extends CollisionShape2D

signal dropped(type)

enum Pieces {ROPE, LEG, GRAVITY, STICK}

export(Pieces) var type

var is_active : bool = false

func _ready():
	self.hide()
	self.disabled = true
	

func connect_piece():
	is_active = true
	self.disabled = false
	self.show()
	
	
func drop():
	is_active = false
	self.disabled = true
	self.hide()
	emit_signal("dropped", type)
