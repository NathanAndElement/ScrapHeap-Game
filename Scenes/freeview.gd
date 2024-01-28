extends CharacterBody2D

@export var speed = 200.0

func  _physics_process(delta):
	#Player movement
	var input_direction =  Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up"))
	
	velocity = input_direction * speed
	move_and_slide();
