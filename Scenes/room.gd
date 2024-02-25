extends Node

var close_doors = {}
var offset_distance = 512  # Adjust based on your door size or desired distance from the center

@export var door_states = {
	Vector2(1,0): true,   # Right door
	Vector2(-1,0): true,  # Left door
	Vector2(0,1): true,   # Bottom door
	Vector2(0,-1): true   # Top door
}

@export var start_room = false;
@export var hidden_doors = {
	Vector2(1,0): false,
	Vector2(-1,0): false,
	Vector2(0,1): false,
	Vector2(0,-1): false,
}


var door_scene = preload("res://Scenes/door.tscn")
var hidden_door_scene = preload("res://Scenes/hidden_door.tscn")
@onready var tile_map: TileMap = $TileMap

func generate_doors(connected_rooms, hidden):
	var doors_to_add = {}
	for door in connected_rooms.keys():
		if(connected_rooms[door] != null):
			doors_to_add[door] = connected_rooms[door]
	
	for door in door_states:
		if(!connected_rooms[door]):
			close_doors[door] = true
			

	for door in doors_to_add:
		if doors_to_add[door]:
			var new_door = null;
			if(hidden[door] == true):
				new_door = hidden_door_scene.instantiate()
			else:
				new_door = door_scene.instantiate()
			var offset = door * offset_distance  # Calculate offset based on direction
			new_door.position = self.position + offset  # Apply offset to position
			new_door.name = str(door)
			add_child(new_door)  # Add the new door as a child of the current node


func _ready():
	block_unused_doors()
	
func block_unused_doors():
	if(close_doors.size() > 0 and tile_map):
		for direction in close_doors:
			var ground_layer = 1
			var offset = direction * offset_distance  # Calculate offset based on direction
			var door_position = self.position + offset  # Apply offset to position
			var tile_position = tile_map.local_to_map(door_position)
			var source_id = 0
		
			var cells_to_replace = [
				tile_position,
				tile_position - Vector2i(direction.y, direction.x),
				tile_position + Vector2i(direction.y, direction.x)
			]
		
			for cell in cells_to_replace:
				tile_map.set_cell(ground_layer, cell, source_id, Vector2i(3,1))
