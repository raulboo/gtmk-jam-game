extends Node
enum PieceType {SLINGSHOT, LEGS, GRAVITY, INMORTAL, SPEED_BOOST}
var game_version = "2.0"
var player_main_node: Node = null

func setup (player_main):
	player_main_node = player_main
