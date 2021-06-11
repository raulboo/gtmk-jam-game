extends RigidBody2D

var force = Vector2(0, 0)
func get_input():
	if Input.is_action_just_released("Mouse_right"):
		gravity_scale -= 4
	if Input.is_action_just_released("Mouse_left") and gravity_scale < 0:
		force.x = (get_global_mouse_position().x - position.x)
		gravity_scale = 9
func _physics_process(delta):
	applied_force = force
	get_input()
