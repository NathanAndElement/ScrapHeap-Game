extends Node2D

@export var life_span = 5
@export var speed = 20.0
@export var wobble_intensity = 0
@export var wobble_intensity_timer_duration = 0
@export var rotation_offset = 0 #The amount in degrees to rotate the bullet from initalization
@export var damage = 10
@export_range(0,0.3) var rotation_speed = 0 #The speed at which spew_offset is hit

@onready var wobble_timer: Timer = $WobbleTimer

var wobble_direction = randf_range(-1, 1)
var current_rotation = 0

func _ready():
	if wobble_intensity > 0:
		wobble_timer.start(wobble_intensity_timer_duration)

func _physics_process(delta):
	life_span -= delta
	if life_span <= 0:
		queue_free()
	
	var move_vec = transform.x * speed
	global_position += move_vec * delta
	
   # Wobble effect
	global_position.y += wobble_direction * wobble_intensity
	
	# Spew effect
	if current_rotation <= rotation_offset:
		rotation_degrees += rotation_speed
		current_rotation += rotation_speed


func _on_wobble_timer_timeout():
	wobble_direction = randf_range(-1, 1)
	wobble_timer.start(wobble_intensity_timer_duration)

func _on_area_2d_area_entered(area):
	if area.name == 'DamageArea':
		var player = area.get_parent()
		player.on_damage(damage)
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == 'TileMap':
		queue_free()
