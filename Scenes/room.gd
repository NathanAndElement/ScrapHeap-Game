extends Node

@export var door_states = {
	Vector2(1,0): true,   # Right door
	Vector2(-1,0): true,  # Left door
	Vector2(0,1): true,   # Bottom door
	Vector2(0,-1): true   # Top door
}

var door_scene = preload("res://Scenes/door.tscn")

func _enter_tree():
	var offset_distance = 240  # Adjust based on your door size or desired distance from the center
	for door in door_states:
		if door_states[door]:
			var new_door = door_scene.instantiate()
			var offset = door * offset_distance  # Calculate offset based on direction
			new_door.position = self.position + offset  # Apply offset to position
			new_door.name = str(door)
			add_child(new_door)  # Add the new door as a child of the current node
			

func delete_unused_doors(doors):
	for door in doors:
		print(is_inside_tree())
		remove_child(get_node(str(door)))
