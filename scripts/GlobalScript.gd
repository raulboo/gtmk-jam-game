extends Node
enum PieceType {SLINGSHOT, LEGS, GRAVITY, INMORTAL, SPEED_BOOST}
var game_version = "2.1"
var player_main_node: Node = null

#TODO: load from memory
var current_level:int = 1
var current_season:int = 1

func setup (player_main):
	player_main_node = player_main
