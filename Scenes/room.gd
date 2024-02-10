extends Node

@export var door_states = {
	Vector2(1,0): true,   # Right door
	Vector2(-1,0): true,  # Left door
	Vector2(0,1): true,   # Bottom door
	Vector2(0,-1): true   # Top door
}

@export var hidden_room = false;

var door_scene = preload("res://Scenes/door.tscn")
var hidden_door_scene = preload("res://Scenes/hidden_door.tscn")

func generate_doors(connected_rooms):
	var doors_to_add = {}	
	for door in connected_rooms.keys():
		if(connected_rooms[door] != null):
			doors_to_add[door] = connected_rooms[door]
	
	var offset_distance = 240  # Adjust based on your door size or desired distance from the center
	for door in doors_to_add:
		if doors_to_add[door]:
			var new_door = null;
			if(hidden_room == true):
				new_door = hidden_door_scene.instantiate()
				
			else:
				new_door = door_scene.instantiate()
			var offset = door * offset_distance  # Calculate offset based on direction
			new_door.position = self.position + offset  # Apply offset to position
			new_door.name = str(door)
			add_child(new_door)  # Add the new door as a child of the current node
