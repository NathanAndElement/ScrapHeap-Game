extends Node

var room = preload("res://Scenes/room_variants.tscn")

var connected_rooms = {
	Vector2(1,0): null,
	Vector2(-1,0): null,
	Vector2(0,1): null,
	Vector2(0,-1): null,
}

var number_of_connections = 0
