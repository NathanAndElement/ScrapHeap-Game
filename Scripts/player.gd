extends CharacterBody2D

@export var speed: float = 100.0
@export var max_health: float = 100.0
@export var health_regen = 1
@export var health_regen_timer = 1
@export var invincibility_timer_wait = .5

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var healthBar: ProgressBar = $HeathBar
@onready var health = max_health
@onready var regen_timer = $RegenTimer
@onready var invincibility_timer = $InvincibilityTimer
@onready var colliding_enemies = []

var invincible = false

signal Damage

func _ready():
	regen_timer.wait_time = health_regen_timer
	update_health()
	Damage.connect(on_damage)
	
func  _physics_process(delta):
	#Player movement
	var input_direction =  Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up"))
	
	velocity = input_direction * speed
	if(input_direction[0] != 0 or input_direction[1] != 0):
		animationPlayer.play("walk")
	else:
		animationPlayer.play("idle")
	move_and_slide();

	#cycle through enemies we have collided with and damage
	if !invincible:
		if colliding_enemies.size() > 0:
			invincible = true
			invincibility_timer.start(invincibility_timer_wait)
			health -= colliding_enemies[0].damage
			update_health()
			
	#Kill player
	if health <= 0:
		kill_player()
	
func update_health():
	healthBar.value = health
	
func kill_player():
	visible = false

func _on_regen_timer_timeout():
	if health < 100:
		health += health_regen
		if health > max_health:
			health = max_health
	if health <= 0:
		health = 0
	update_health()


func _on_invincibility_timer_timeout():
	invincible = false
	

func on_damage(damage):
	if !invincible:
		invincible = true
		invincibility_timer.start(invincibility_timer_wait)
		health -= damage
		update_health()
