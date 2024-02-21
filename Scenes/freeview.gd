extends CharacterBody2D

@export var speed = 200.0
@onready var camera = $Camera2D
@export var enabled = true

func _ready():
	if(!enabled):
		queue_free()

func  _physics_process(delta):
	#Player movement
	var input_direction =  Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up"))
	
	if Input.get_action_strength("Camera Zoom In"):
		camera.zoom.x += 0.001
		camera.zoom.y += 0.001
	if Input.get_action_strength("Camera Zoom Out"):
		camera.zoom.x -= 0.001
		camera.zoom.y -= 0.001
	
	velocity = input_direction * speed
	move_and_slide();
