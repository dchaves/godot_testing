extends Node

const ACCEL = 1500
const MAX_SPEED = 500
const FRICTION = -500
const GRAVITY = 2000
const SPEED = 250 # MOVE AT CONSTANT SPEED
const JUMP_SPEED = -1000
const MIN_JUMP_SPEED = -500

var acc = Vector2()
var vel = Vector2()
var isdead = false

onready var ground_ray = get_node("ground_ray")
onready var sprite = get_node("AnimatedSprite")
onready var player = get_node("AnimationPlayer")
onready var collider = get_node("CollisionShape2D")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	
func _input(event):
	if event.is_action_released("ui_up"):
        vel.y = clamp(vel.y, MIN_JUMP_SPEED, vel.y)
	if event.is_action_pressed("ui_up") and ground_ray.is_colliding():
		vel.y = JUMP_SPEED
	if event.is_action_pressed("ui_focus_next") and ground_ray.is_colliding():
		var weapon = load("res://saw.tscn")
		var activeweapon = weapon.instance()
		activeweapon.set_pos(get_pos() + Vector2(128,0))
		get_node("..").add_child(activeweapon)
	
func _fixed_process(delta):
	if(isdead):
		return
	var animation = "idle"
	#acc.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	#acc.x *= ACCEL
	acc.y = GRAVITY
	#if acc.x == 0:
	#	acc.x = vel.x * FRICTION * delta
	#vel += acc * delta
	vel.x = SPEED * (Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left"))#clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	vel.y += acc.y * delta
	if(abs(vel.y) < 10):
		vel.y = 0
	
	if(self.is_colliding()):
		var withother = self.get_collider()
		if (withother.is_in_group("deadly")):
			self.remove_and_skip()
			return
	
	if(ground_ray.is_colliding()):
		if (vel.x > 0):
			animation = "walk"
			sprite.set_flip_h(false)
		elif (vel.x < 0):
			animation = "walk"
			sprite.set_flip_h(true)
	else:
		if (vel.x >= 0):
			animation = "jump"
			sprite.set_flip_h(false)
		elif (vel.x < 0):
			animation = "jump"
			sprite.set_flip_h(true)
	sprite.play(animation)

	var motion = move(vel * delta)
	if(ground_ray.is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		vel = n.slide(vel)
		move(motion)