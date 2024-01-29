extends Node

@export var door_states = {
	Vector2(1,0): true,   # Right door
	Vector2(-1,0): true,  # Left door
	Vector2(0,1): true,   # Bottom door
	Vector2(0,-1): true   # Top door
  }
