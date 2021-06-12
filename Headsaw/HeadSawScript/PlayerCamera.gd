extends Camera2D

#ATENTION, IN THIS SCRIPT YOU MUST LET THE CAMERA 
#ON THE SAME POSITION OF THE MAIN NODE
#OF THE SCENE OTHERWISE THE CAMERA LIMIT
#WILL NOT WORK WAS SUPPOSED TO BE

onready var target = get_parent().find_node("Player")
onready var UpLeft = get_node("UpLeft")
onready var DownRight = get_node("DownRight")
func _ready():
	limit_right = DownRight.position.x
	limit_bottom = DownRight.position.y
	limit_left = UpLeft.position.x
	limit_top = UpLeft.position.y

func _process(delta):
	position = Vector2(target.position.x, target.position.y)
