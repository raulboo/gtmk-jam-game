extends Node

enum Loops {MENU, GP1, GP2}

var current_loop : int

func _ready():
	current_loop = Loops.MENU
	$LoopMenu.play()	
	
	
func switch_loop(new_loop : int):
	current_loop = new_loop
#
#	for loop in get_children():
#		if loop.playing:
#

func _on_Loop_finished():
	self.get_child(current_loop).play()
