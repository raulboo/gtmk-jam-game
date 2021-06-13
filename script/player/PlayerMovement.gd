extends KinematicBody2D
class_name Player

signal player_dead

var is_noclipping := false

export(int) var gravity_acceleration = 30
export(float) var jump_force = 1000
export(float) var lateral_speed = 300

var gravity_current = gravity_acceleration
var acceleration = Vector2(0, 0)
var velocity = Vector2(0, 0)

var up_direction = Vector2.UP

var on_rope_momentuum := false

#TODO: check delta multiplication
func _physics_process(delta):
	
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
									# else
		
	if not on_rope_momentuum:
		velocity.x = ((- int(Input.is_action_pressed("move_left")) 
				+ int(Input.is_action_pressed("move_right"))) * lateral_speed)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_force


	if Input.is_action_just_pressed("debug_noclip"):
		is_noclipping = !is_noclipping
	if is_noclipping:
		velocity = ((int(Input.is_action_pressed("ui_up")) * Vector2(0, -1)) +
					(int(Input.is_action_pressed("ui_down")) * Vector2(0, 1)) +
					(int(Input.is_action_pressed("ui_left")) * Vector2(-1, 0)) +
					(int(Input.is_action_pressed("ui_right")) * Vector2(1, 0))) * jump_force
	
	#velocity += acceleration
	velocity = move_and_slide(velocity, up_direction)
	#acceleration = Vector2.ZERO
	check_hostile_collisions()
	
	if get_slide_count() > 0:
		on_rope_momentuum = false
	
	if velocity.x != 0:
		flip_to(sign(velocity.x)) 
		
	if is_on_floor():		
		if velocity.x != 0:
			$AnimatedSprite.play("walking")
		else:
			$AnimatedSprite.play("idle")
			
			
	if Input.is_action_just_pressed("reset_level"):
		self.die()

# Direction -> -1 = left; 1 = right
func flip_to(direction: int):
	$AnimatedSprite.flip_h = (direction < 0)
	$PieceHolder.scale.x = direction
	$FrontCollision.position.x = abs($FrontCollision.position.x) * direction
	$BackCollision.position.x = abs($BackCollision.position.x) * -direction

			
func check_hostile_collisions():
	for i in get_slide_count():
		var object = get_slide_collision(i).collider
		if object.is_in_group("hostile"):
			self.die()

func die():
	emit_signal("player_dead")
	# TODO: reset pieces
	# TODO: reset gravity
