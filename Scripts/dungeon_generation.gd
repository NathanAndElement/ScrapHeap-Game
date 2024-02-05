extends Node

var room = preload("res://Scenes/room.tscn")
var start_room_instance = preload("res://start_rooms.tscn").instantiate()
var end_room_instance = preload("res://end_rooms.tscn").instantiate()
var start_room = start_room_instance.get_node("Start")
var end_room = end_room_instance.get_node("End")

@export var min_number_rooms = 5
@export var max_number_rooms = 10 
@export var generation_chance = 20

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(randf_range(min_number_rooms, max_number_rooms))
	dungeon[Vector2(0,0)] = room.instantiate()
	size -= 1

	var attempt_limit = 10 # Max attempts per iteration
	while size > 0:
		var attempt_count = 0
		var created_room = false
		while not created_room and attempt_count < attempt_limit:
			var keys = dungeon.keys()
			for i in keys:
				if size <= 0:
					break
				var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
				directions.shuffle() # Ensure random direction selection
				for direction in directions:
					if randf() * 100 < generation_chance:
						if create_rooms(dungeon, direction, i):
							size -= 1
							created_room = true
							break # Exit after successful creation
				if created_room:
					break # Break if any room was created in this iteration
			attempt_count += 1
			if not created_room:
				print("Attempt %d failed to create a new room" % attempt_count)
		
		if attempt_count >= attempt_limit and not created_room:
			print("Max attempts reached, unable to create more rooms.")
			break # Optional: Adjust this based on your requirements

	create_start_end_rooms(dungeon)
	return dungeon

func create_rooms(dungeon, direction, i):
	var new_room_position = i + direction
	if not dungeon.has(new_room_position):
		dungeon[new_room_position] = room.instantiate()
		# Assuming is_door_enabled returns true for simplification
		# Connect rooms logic here (simplified for brevity)
		if (dungeon[new_room_position].is_door_enabled(-direction)):
			connect_rooms(dungeon.get(i), dungeon.get(new_room_position), direction)
			return true
		else:
			dungeon.erase(new_room_position)
			return false
	return false
	


func create_start_end_rooms(dungeon):
	var lowest_value = Vector2(0, 0)
	var highest_value = Vector2(0, 0)
	for i in dungeon.keys():
		if i.x < lowest_value.x or (i.x == lowest_value.x and i.y < lowest_value.y):
			lowest_value = i
		if i.x > highest_value.x or (i.x == highest_value.x and i.y > highest_value.y):
			highest_value = i
	dungeon[lowest_value].room = start_room
	dungeon[highest_value].room = end_room

			
func connect_rooms(room1, room2, direction):
		room1.connected_rooms[direction] = room2
		room2.connected_rooms[-direction] = room1
		room1.number_of_connections += 1
		room2.number_of_connections += 1
		
