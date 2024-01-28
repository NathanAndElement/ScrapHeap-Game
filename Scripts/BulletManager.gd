extends Node2D

@onready var bullet


func _ready():
	bullet = load("res://Scenes/Bullet.tscn")

func _rotate(rotation_speed, rotation_direction):
		if rotation_direction == 1:
			rotation_degrees += rotation_speed
		else:
			rotation_degrees -= rotation_speed
	
