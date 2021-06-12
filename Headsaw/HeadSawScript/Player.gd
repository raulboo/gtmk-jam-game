extends KinematicBody2D

var spd = 400
var velocity = Vector2(0.0, -1.0)
var hsp = 0
var vsp = 0

func _get_input():
	if Input.is_action_pressed("move_right"):
		hsp = spd
	elif Input.is_action_pressed("move_left"):
		hsp = -spd
	else:
		hsp = 0
func _physics_process(delta):
	_get_input()
	velocity.x = hsp
	velocity.y = vsp
	velocity = move_and_slide(velocity)
