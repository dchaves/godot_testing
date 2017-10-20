extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var playerscene

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	playerscene = load("res://player.tscn")
	set_process_input(true)
	
func _input(event):
	### CREATE NEW PLAYER NODE
	if (event.is_action_pressed("ui_select")):
		var newplayer = playerscene.instance()
		newplayer.set_pos(get_node("player").get_pos() + Vector2(0,-128))
		get_node(".").add_child(newplayer)