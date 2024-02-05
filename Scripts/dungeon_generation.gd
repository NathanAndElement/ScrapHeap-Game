extends Node

var room = preload("res://Scenes/room.tscn")
var start_room_instance = preload("res://start_rooms.tscn").instantiate()
var end_room_instance = preload("res://end_rooms.tscn").instantiate()
var start_room = start_room_instance.get_node("Start")
var end_room = end_room_instance.get_node("End")

@export var min_number_rooms = 10
@export var max_number_rooms = 10 
@export var generation_chance = 20

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(randf_range(min_number_rooms, max_number_rooms))
	dungeon[Vector2(0,0)] = room.instantiate()
	size -= 1 
	
	while(size > 0):
		
		if(size <= 1):
			create_start_end_rooms(dungeon)
		for i in dungeon.keys():
			if(randf_range(0, 100) < generation_chance):
				var direction = randf_range(0, 4)
				if(direction < 1):
					if(create_rooms(dungeon, Vector2(1, 0), i)):
						size -= 1
				if(direction < 2):
					if(create_rooms(dungeon, Vector2(-1, 0), i)):
						size -= 1
				if(direction < 3):
					if(create_rooms(dungeon, Vector2(0, 1), i)):
						size -= 1
				if(direction < 4):
					if(create_rooms(dungeon, Vector2(0, -1), i)):
						size -= 1
	return dungeon

func create_rooms(dungeon, direction, i):
	var new_room_position = i + direction
	if(!dungeon.has(new_room_position) and dungeon[i].is_door_enabled(direction)):
		dungeon[new_room_position] = room.instantiate()
		if (dungeon[new_room_position].is_door_enabled(-direction)):
			connect_rooms(dungeon.get(i), dungeon.get(new_room_position), direction)
			return true
		else:
			dungeon.erase(new_room_position)
			return false
	return false	
					
func connect_rooms(room1, room2, direction):
		room1.connected_rooms[direction] = room2
		room2.connected_rooms[-direction] = room1
		room1.number_of_connections += 1
		room2.number_of_connections += 1
		
func create_start_end_rooms(dungeon):
	var lowest_value = Vector2(0, 0)
	var highest_value = Vector2(0, 0)
	
	for i in dungeon.keys():
		if(i < lowest_value):
			lowest_value = i
		if(i > highest_value):
			highest_value = i
	dungeon[lowest_value].room = start_room
	dungeon[highest_value].room = end_room
	
