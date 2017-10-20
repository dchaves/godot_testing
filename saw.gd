extends KinematicBody2D

const SPEED = 500 
var vel = Vector2()

onready var border_left = get_node("border_left")
onready var border_right = get_node("border_right")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	vel.y = 0
	vel.x = SPEED
	set_fixed_process(true)
	
func _fixed_process(delta):
	if border_left.is_colliding() and border_right.is_colliding():
		move(vel * delta)