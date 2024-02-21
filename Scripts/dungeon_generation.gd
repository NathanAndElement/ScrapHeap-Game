extends Node

var room = preload("res://Scenes/room.tscn")
var start_room_instance = preload("res://Scenes/start_rooms.tscn").instantiate()
var end_room_instance = preload("res://Scenes/end_rooms.tscn").instantiate()
var hidden_room_instance = preload("res://Scenes/hidden_rooms.tscn").instantiate()
var hidden_room = hidden_room_instance.get_node("Hidden1")



@export var min_number_rooms = 5
@export var max_number_rooms = 10 
@export var generation_chance = 20
@export var hidden_room_chance = 10
@export var hidden_room_loops = 10

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
			break
	create_start_end_rooms(dungeon)
	
	create_hidden_rooms(dungeon)
	return dungeon

func create_rooms(dungeon, direction, i):
	var new_room_position = i + direction
	if not dungeon.has(new_room_position):
		dungeon[new_room_position] = room.instantiate()
		if (dungeon[new_room_position].is_door_enabled(-direction)):
			connect_rooms(dungeon.get(i), dungeon.get(new_room_position), direction)
			return true
		else:
			dungeon.erase(new_room_position)
			return false
	return false
	

func create_start_end_rooms(dungeon):
	var lowest_value = Vector2(INF, INF)  # Initialize with a large value
	var highest_value = Vector2(-INF, -INF)  # Initialize with a small value
	for i in dungeon.keys():
		var current_direction = check_directions(dungeon[i], i, false)
		if current_direction != null:
			if i.x < lowest_value.x or (i.x == lowest_value.x and i.y < lowest_value.y):
				if(!dungeon.has(i + current_direction )):
					lowest_value = i
			if i.x > highest_value.x or (i.x == highest_value.x and i.y > highest_value.y):
				if(!dungeon.has(i + current_direction )):
					highest_value = i

	if lowest_value != Vector2(INF, INF) and highest_value != Vector2(-INF, -INF):
		dungeon[lowest_value].type = 'start'
		dungeon[highest_value].type = 'end'



func create_hidden_rooms(dungeon):
	#Rooms that are potentially free tiles with potential doors

	var potential_links = {}
	for i in dungeon.keys():
		var room = dungeon[i]
		#check the room connections
		if(!room.connected_rooms[Vector2(0, 1)] and room.is_door_enabled(Vector2(0, 1))):
			#make sure the room doesnt already exist on the new given index as this would make connected_rooms incorrect
			if(!dungeon.has(i + Vector2(0, 1)) ):
				potential_links[i + Vector2(0, 1)] = Vector2(0, 1)
		if(!room.connected_rooms[Vector2(0, -1)] and room.is_door_enabled(Vector2(0, -1))):
			if(!dungeon.has(i + Vector2(0, -1))):
				potential_links[i + Vector2(0, -1)] = Vector2(0, -1)
		if(!room.connected_rooms[Vector2(1, 0)] and room.is_door_enabled(Vector2(1, 0))):
			if(!dungeon.has(i + Vector2(1, 0))):
				potential_links[i + Vector2(1, 0)] = Vector2(1, 0)
		if(!room.connected_rooms[Vector2(-1, 0)] and room.is_door_enabled(Vector2(-1, 0))):
			if(!dungeon.has(i + Vector2(-1, 0))):
				potential_links[i + Vector2(-1, 0)] = Vector2(-1, 0)
	#Loop through potential links and use spawn chance to decide whether to spawn a hidden room there or not
	for i in potential_links.keys():
		var disableEntity = false
		if randf() * 100 < hidden_room_chance:
#We need to do this to make sure that the index we are creating the hidden room on is not adjacent to a start or end room causing breaking bugs 
			if(dungeon.get(i + Vector2(0, 1))):
				if(dungeon.get(i + Vector2(0, 1)).room.name == 'Start' or  dungeon.get(i + Vector2(0, 1)).room.name == 'End'):
					disableEntity = true
			if(dungeon.get(i + Vector2(0, -1))):
				if(dungeon.get(i + Vector2(0, -1)).room.name == 'Start' or  dungeon.get(i + Vector2(0, -1)).room.name == 'End'):
					disableEntity = true
			if(dungeon.get(i + Vector2(1, 0))):
				if(dungeon.get(i + Vector2(1, 0)).room.name == 'Start' or  dungeon.get(i + Vector2(1, 0)).room.name == 'End'):
					disableEntity = true
			if(dungeon.get(i + Vector2(-1, 0))):
				if(dungeon.get(i + Vector2(-1, 0)).room.name == 'Start' or  dungeon.get(i + Vector2(-1, 0)).room.name == 'End'):
					disableEntity = true
				
			if(!disableEntity):
				dungeon[i] = room.instantiate()
				dungeon[i].room = hidden_room
				connect_rooms(dungeon.get(i - potential_links[i]), dungeon.get(i), potential_links[i])
				dungeon[i - potential_links[i]].room.hidden_doors[potential_links[i]] = true
		hidden_room_loops -= 1


func connect_rooms(room1, room2, direction):
		room1.connected_rooms[direction] = room2
		room2.connected_rooms[-direction] = room1
		room1.number_of_connections += 1
		room2.number_of_connections += 1
		

func check_directions(room, index, switch):
	if(!room.connected_rooms[Vector2(0, 1)] and room.is_door_enabled(Vector2(0, 1))):
		if(switch):
			return room
		else:
			return index
	if(!room.connected_rooms[Vector2(0, -1)] and room.is_door_enabled(Vector2(0, -1))):
		if(switch):
			return room
		else:
			return index
	if(!room.connected_rooms[Vector2(1, 0)] and room.is_door_enabled(Vector2(1, 0))):
		if(switch):
			return room
		else:
			return index
	if(!room.connected_rooms[Vector2(-1, 0)] and room.is_door_enabled(Vector2(-1, 0))):
		if(switch):
			return room
		else:
			return index
	pass
		
