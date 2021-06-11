extends PathFollow2D

signal changed_position(new_position)

func _physics_process(delta):
	self.position += Vector2(2, 0)
	
	emit_signal("changed_position", global_position)
