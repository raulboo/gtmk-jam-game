extends MarginContainer

#const first_option = preload()
#const second_option = "preload()

onready var selection_one = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector
onready var selection_two = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector
export(PackedScene) var first_level

var current_selection = 0

func _process(_delta):
	if Input.is_action_pressed("start_game"):
		get_tree().change_scene_to(first_level)
		
#func _ready():
#	setcurrent_selection(0)
	
#	if Input.is_action_just_pressed("ui_down") and current_selection < 1:
#		current_selection += 1
#		setcurrent_selection(current_selection)
#	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
#		current_selection += -1
#		setcurrent_selection(current_selection)
#	elif Input.is_action_just_pressed("ui_accept"):
#		handle_selection(current_selection)

#func handle_selection(current_selection):
#	print("working, i think ", current_selection)
	#if current_selection == 0:
		#get_parent().add_child(first_option.instance())
		#queue_free()
	#elif current_selection == 1:
		#get_tree().quit()
	
#func setcurrent_selection(current_selection):
#	selection_one.text = ""
#	selection_two.text = ""
#	if current_selection == 0:
#		selection_one.text = ">"
#	if current_selection == 1:
#		selection_two.text = ">"
