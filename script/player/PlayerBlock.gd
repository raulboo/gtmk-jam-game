class_name Player
extends KinematicBody2D

signal dead

export(int) var gravity_acceleration = 30

var is_on_click_mode = false

onready var gravity_current = gravity_acceleration
onready var acceleration := Vector2(0, 0)
onready var velocity := Vector2(0, 0)

#TODO: chedck delta multiplication
func _physics_process(delta):
	velocity.y += gravity_current
	
	if is_on_floor():
		is_on_click_mode = false
	#if Input.is_action_just_released("Mouse_right"):
		#gravity_scale -= 4
	if is_on_click_mode:# and gravity_scale < 0:
		if Input.is_action_pressed("mouse_left"):
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

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y -= 1000

	
	velocity += acceleration
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	for i in get_slide_count():
		var object = get_slide_collision(i).collider
		if object.is_in_group("hostile"):
			self.die()
			
func die():
	emit_signal("dead")


func on_piece_attached(type):
	match type:
		"LEG":
			print("AAAAAAAAAAAAAAAAAA")
	
	print("attached ", type)


func on_piece_de_attached(type):
	print("de_attached ", type)
