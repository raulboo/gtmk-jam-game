extends KinematicBody2D
class_name Player

signal player_dead

var is_noclipping := false

export(int) var gravity_acceleration = 30
export(float) var jump_force = 1000
export(float) var lateral_speed = 300

var gravity_current = gravity_acceleration
var velocity = Vector2(0, 0)

var moving_lateral = 0
var jumping = false

var using_slingshot = false

func _process(_delta):
	if Input.is_action_just_pressed("reset_level"):
		self.die()

	moving_lateral = 0
	if Input.is_action_pressed("move_right"):
		moving_lateral = 1
	elif Input.is_action_pressed("move_left"):
		moving_lateral = -1
	
	jumping = false
	if Input.is_action_pressed("jump"):
		jumping = true
	

func _physics_process(_delta):
	velocity.y += gravity_current
		
	if !using_slingshot:
		velocity.x = (moving_lateral * lateral_speed)

	if jumping && is_on_floor():
		velocity.y -= jump_force
		play_sfx("Jump")
		$AnimatedSprite.play("jump")
	
	#debug_checks()

	var up_direction = Vector2.UP;
	if gravity_current < 0:
		up_direction = Vector2.DOWN

	velocity = move_and_slide(velocity, up_direction)

	if get_slide_count() > 0:
		using_slingshot = false

	check_hostile_collisions()
	
	if velocity.x != 0:
		flip_to(sign(velocity.x))
		$AnimatedSprite.play("walking")
	else:
		$AnimatedSprite.play("idle")

func flip_to(direction):
	$AnimatedSprite.flip_h = (direction < 0)
	$PieceHolder.scale.x = direction
	$RightCollider.position.x = abs($RightCollider.position.x) * direction
	$LeftCollider.position.x = abs($LeftCollider.position.x) * -direction

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


func play_sfx(name : String):
	$SFX.get_node(name).play()

func die():
	$SFX/Death.play()
	$PieceController.de_attach_all_pieces()
	$PowerUpManager.reset_gravity()
	emit_signal("player_dead")
