extends HBoxContainer
export(PackedScene) var coin_scene
export(float) var separation

func _ready():
	set("custom_constants/separation", separation)

func add_coin():
	var coin = coin_scene.instance()
	add_child(coin)

func reset():
	for c in get_children():
		c.queue_free()
