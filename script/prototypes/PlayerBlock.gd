extends KinematicBody2D

export(int) var gravity_acceleration = 30

var is_on_click_mode = false

onready var gravity_current = gravity_acceleration
onready var acceleration := Vector2(0, 0)
onready var velocity := Vector2(0, 0)

func _physics_process(delta):
	velocity.y += gravity_current
	
	if Input.is_action_pressed("Mouse_left") and $RopePiece.is_active:
		is_on_click_mode = true
	elif is_on_floor():
		is_on_click_mode = false
	#if Input.is_action_just_released("Mouse_right"):
		#gravity_scale -= 4
	if is_on_click_mode:# and gravity_scale < 0:
		if Input.is_action_pressed("Mouse_left"):
			acceleration = (get_global_mouse_position() - self.global_position)/10
			velocity.y -= gravity_current
		else:
			acceleration = Vector2(0, 0)
		#gravity_current = 0
		#gravity_scale = 9
	else:
		acceleration = Vector2(0, 0)
	
		velocity.x = ((- int(Input.is_action_pressed("move_left")) 
				+ int(Input.is_action_pressed("move_right"))) * 300)
		var is_lforr = is_on_floor()
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y -= 1000

	
	velocity += acceleration
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	for i in get_slide_count():
		var object = get_slide_collision(i).collider
		if object.is_in_group("jigsaw_piece"):
			object.fit_in_character()
			self.get_child(object.type).connect_piece()
