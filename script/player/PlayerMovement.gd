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
var on_rope_momentum := false

#TODO: check delta multiplication
func _physics_process(_delta):
	velocity.y += gravity_current
		
	if not on_rope_momentum:
		velocity.x = ((- int(Input.is_action_pressed("move_left")) 
				+ int(Input.is_action_pressed("move_right"))) * lateral_speed)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_force
	
	debug_checks()

	#velocity += acceleration
	velocity = move_and_slide(velocity, up_direction)
	#acceleration = Vector2.ZERO
	check_hostile_collisions()
	
	if get_slide_count() > 0:
		on_rope_momentum = false
	
	if velocity.x != 0:
		flip_to(sign(velocity.x))
		$AnimatedSprite.play("walking")
	else:
		$AnimatedSprite.play("idle")
		
	if Input.is_action_just_pressed("reset_level"):
		self.die()

# Direction -> -1 = left; 1 = right
func flip_to(direction):
	$AnimatedSprite.flip_h = (direction < 0)
	$PieceHolder.scale.x = direction
	$FrontCollision.position.x = abs($FrontCollision.position.x) * direction
	$BackCollision.position.x = abs($BackCollision.position.x) * -direction

			
func check_hostile_collisions():
	for i in get_slide_count():
		var object = get_slide_collision(i).collider
		if object.is_in_group("hostile"):
			self.die()

func debug_checks():
	if Input.is_action_just_pressed("debug_noclip"):
		is_noclipping = !is_noclipping
	if is_noclipping:
		velocity = ((int(Input.is_action_pressed("ui_up")) * Vector2(0, -1)) +
					(int(Input.is_action_pressed("ui_down")) * Vector2(0, 1)) +
					(int(Input.is_action_pressed("ui_left")) * Vector2(-1, 0)) +
					(int(Input.is_action_pressed("ui_right")) * Vector2(1, 0))) * jump_force

func die():
	emit_signal("player_dead")
	# TODO: reset pieces
	# TODO: reset gravity
