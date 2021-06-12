extends KinematicBody2D

export(int) var jump_velocity_base = 400

onready var jump_velocity : int = jump_velocity_base
onready var velocity := Vector2(0, 0)

func _physics_process(delta):
	velocity.y += 30
	
	velocity.x = ((- int(Input.is_action_pressed("move_left")) 
				+ int(Input.is_action_pressed("move_right"))) * 300)
				
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_velocity
	
	velocity = move_and_slide(velocity, Vector2(0, 1))


func consume(slime: Area2D):
	$CollisionShape2D.shape.extents += slime.get_node("CollisionShape2D").shape.extents/2
	jump_velocity += jump_velocity_base/2
