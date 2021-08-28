extends Node

onready var kinematic_body = get_parent()
onready var animated_sprite = $"../AnimatedSprite"
onready var piece_holder = $"../PieceHolder"
onready var r_collider = $"../RightCollider"
onready var l_collider = $"../LeftCollider"

export(float) var ACCELERATION_SPEED = 0.25
export(float) var DE_ACCELERATION_SPEED = 0.5
export(float) var MAX_WALKING_SPEED = 300
export(float) var JUMP_FORCE = 900
export(float) var GRAVITY_FORCE = 4000

var velocity = Vector2.ZERO
var current_max_speed = MAX_WALKING_SPEED
var current_gravity_force = GRAVITY_FORCE
var speed_multiplier = 1

var facing_direction = 1
var gravity_direction = 0

var moving_input = 0
var jump_input = false

func _physics_process(delta):
	process_input()
	process_movement(delta)
	calculate_animations()
	calculate_directions()

func process_input():
	moving_input = 0
	if Input.is_action_pressed("move_right"):
		moving_input = 1
	if Input.is_action_pressed("move_left"):
		moving_input = -1

	jump_input = false
	if Input.is_action_just_pressed("jump"):
		jump_input = true

#physics calculations
func process_movement(delta):
	if  moving_input != 0:
		velocity.x = lerp(velocity.x, moving_input * current_max_speed * speed_multiplier, ACCELERATION_SPEED)
	elif moving_input == 0 and kinematic_body.is_on_floor():
		velocity.x = lerp(velocity.x, 0, DE_ACCELERATION_SPEED)

	velocity.y += current_gravity_force * delta

	if jump_input and kinematic_body.is_on_floor():
		velocity.y = -JUMP_FORCE * gravity_direction

	if(abs(velocity.x) < 1):
		velocity.x = 0
	
	velocity = kinematic_body.move_and_slide(velocity, Vector2(0, -gravity_direction))

#plays the proper animations
func calculate_animations():
	if velocity.x != 0:
		if facing_direction != -sign(velocity.x):
			flip_to(facing_direction)
		
		animated_sprite.play("walking")
	elif !kinematic_body.is_on_floor():
		animated_sprite.play("jump")
	else:
		animated_sprite.play("idle")

#calculate facing direction and gravity direction
func calculate_directions():
	gravity_direction = sign(current_gravity_force)

	if velocity.x != 0:
		facing_direction = sign(velocity.x)

#flips player to direction
func flip_to(direction):
	animated_sprite.flip_h = (direction < 0)
	piece_holder.scale.x = direction
	r_collider.position.x = abs(r_collider.position.x) * direction
	l_collider.position.x = abs(l_collider.position.x) * -direction
