extends KinematicBody2D
class_name Player

signal player_dead

export(int) var gravity_acceleration = 30
export(float) var jump_force = 1000
export(float) var lateral_speed = 300

var gravity_current = gravity_acceleration
var acceleration = Vector2(0, 0)
var velocity = Vector2(0, 0)

#TODO: check delta multiplication
func _physics_process(_delta):
	velocity.y += gravity_current
	
	#Raz: Raul idk what is this for, so I just commented it, the player moves anyways, you can uncomment if you want:
									# if is_on_floor():
									# 	is_on_click_mode = false
									# #if Input.is_action_just_released("Mouse_right"):
									# 	#gravity_scale -= 4
									# if is_on_click_mode:# and gravity_scale < 0:
									# 	if Input.is_action_pressed("mouse_left"):
									# 		acceleration = (get_global_mouse_position() - self.global_position)/10
									# 		velocity.y -= gravity_current
									# 	else:
									# 		acceleration = Vector2(0, 0)
									# 	#gravity_current = 0
									# 	#gravity_scale = 9
									# else:

	acceleration = Vector2.ZERO

	velocity.x = ((- int(Input.is_action_pressed("move_left")) 
			+ int(Input.is_action_pressed("move_right"))) * lateral_speed)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_force

	
	velocity += acceleration
	velocity = move_and_slide(velocity, Vector2.UP)
	check_hostile_collisions()

			
func check_hostile_collisions():
	for i in get_slide_count():
		var object = get_slide_collision(i).collider
		if object.is_in_group("hostile"):
			self.die()

func die():
	emit_signal("player_dead")