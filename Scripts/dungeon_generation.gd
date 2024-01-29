extends Node

var room = preload("res://Scenes/room.tscn")

@export var min_number_rooms = 6
@export var max_number_rooms = 10 

@export var generation_chance = 20

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(randf_range(min_number_rooms, max_number_rooms))
	
	dungeon[Vector2(0,0)] = room.instantiate()
	size -= 1
	
	while(size > 0):
		for i in dungeon.keys():
			if(randf_range(0, 100) < generation_chance):
				var direction = randf_range(0, 4)
				if(direction < 1):
					var new_room_position = i + Vector2(1, 0)
					print(dungeon[i])
					if(!dungeon.has(new_room_position) and dungeon[i].is_door_enabled(Vector2(1, 0))):
						dungeon[new_room_position] = room.instantiate()
						size -= 1
					connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(1, 0))
				if(direction < 2):
					var new_room_position = i + Vector2(-1, 0)
					if(!dungeon.has(new_room_position) and dungeon[i].is_door_enabled(Vector2(-1, 0))):
						dungeon[new_room_position] = room.instantiate()
						size -= 1
					connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(-1, 0))
				if(direction < 3):
					var new_room_position = i + Vector2(0, 1)
					if(!dungeon.has(new_room_position) and dungeon[i].is_door_enabled(Vector2(0, 1))):
						dungeon[new_room_position] = room.instantiate()
						size -= 1
					connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0, 1))
				if(direction < 4):
					var new_room_position = i + Vector2(0, -1)
					if(!dungeon.has(new_room_position) and dungeon[i].is_door_enabled(Vector2(0, -1))):
						dungeon[new_room_position] = room.instantiate()
						size -= 1
					connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0, -1))
	return dungeon
					
func connect_rooms(room1, room2, direction):
	if room1.is_door_enabled(direction) and room2.is_door_enabled(-direction):
		room1.connected_rooms[direction] = room2
		room2.connected_rooms[-direction] = room1
		room1.number_of_connections += 1
		room2.number_of_connections += 1
	else:
		print("Connection blocked due to a disabled door")
