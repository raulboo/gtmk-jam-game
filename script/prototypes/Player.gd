extends KinematicBody2D

export(int) var chain_length = 400

onready var velocity := Vector2(0, 0)

func _physics_process(delta):
	velocity.y += 30
	
	velocity.x = ((- int(Input.is_action_pressed("move_left")) 
				+ int(Input.is_action_pressed("move_right"))) * 300)
	if Input.is_action_just_pressed("jump"):
		velocity.y -= 1000
	
	velocity = move_and_slide(velocity, Vector2(0, 1))


func _on_Trackpoint_changed_position(trackpoint_position):
	if self.global_position.distance_squared_to(trackpoint_position) > pow(chain_length,2):
		self.global_position = (trackpoint_position + 
								(self.global_position-trackpoint_position).clamped(chain_length)
								)
		velocity.x = ((- int(Input.is_action_pressed("move_left")) 
				+ int(Input.is_action_pressed("move_right"))) * 600)
