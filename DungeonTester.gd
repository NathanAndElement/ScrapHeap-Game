extends Node2D

var dungeon = {}
var node_sprite = load("res://Sprites/map_nodes1.png")
var branch_sprite = load("res://Sprites/map_nodes3.png")
var room_variants = load("res://Scenes/room_variants.tscn")
var start_room_variants = load("res://Scenes/start_rooms.tscn")
var hidden_room_variants = load("res://Scenes/hidden_rooms.tscn")
var end_room_variants = load("res://Scenes/end_rooms.tscn")

@onready var map_node = $MapNode

func _ready():
	dungeon = DungeonGeneration.generate(533)
	load_map()

func load_map():
	for i in range(0, map_node.get_child_count()):
		map_node.get_child(i).queue_free()
	
	for i in dungeon:
		if(dungeon[i].room.name == 'Hidden1'):
			var hidden_room_instance = hidden_room_variants.instantiate()
			var hidden_room = hidden_room_instance.get_node("Hidden1")
			hidden_room.generate_doors(dungeon[i].connected_rooms, hidden_room.hidden_doors)
			hidden_room.process_mode = 0 # = Mode: Inherit
			hidden_room.show()
			map_node.add_child(hidden_room_instance)
			hidden_room_instance.z_index = 1
			hidden_room_instance.position = i * 514
			
		if(dungeon[i].room.name == 'End' or dungeon[i].room.name == 'Start'):
			var start_room_instance = start_room_variants.instantiate()
			var start_room = start_room_instance.get_node("Start")
			start_room.generate_doors(dungeon[i].connected_rooms, dungeon[i].room.hidden_doors)
			print(dungeon[i].room.hidden_doors, 'hidden')
			print(dungeon[i].room.door_states, 'door_states')
			start_room.process_mode = 0 # = Mode: Inherit
			start_room.show()
			map_node.add_child(start_room_instance)
			start_room_instance.z_index = 1
			start_room_instance.position = i * 514
			
			var end_room_instance = end_room_variants.instantiate()
			var end_room = end_room_instance.get_node("End")
			end_room.generate_doors(dungeon[i].connected_rooms, dungeon[i].room.hidden_doors)
			end_room.process_mode = 0 # = Mode: Inherit
			end_room.show()
			map_node.add_child(end_room_instance)
			end_room_instance.z_index = 1
			end_room_instance.position = i * 514
		else:
			
			var room_instance = dungeon[i].room_scene.instantiate()
			var room = room_instance.get_child(dungeon[i].room_index)
			room.generate_doors(dungeon[i].connected_rooms, dungeon[i].room.hidden_doors)
			room.process_mode = 0 # = Mode: Inherit
			room.show()
			map_node.add_child(room_instance)
			room_instance.z_index = 1
			room_instance.position = i * 514
		var c_rooms = dungeon[i].connected_rooms
		var temp = Sprite2D.new()
		temp.texture = node_sprite
		if(c_rooms.get(Vector2(1, 0)) != null):
			temp = Sprite2D.new()
			temp.texture = branch_sprite
			map_node.add_child(temp)
			temp.z_index = 0
			temp.position = i * 514 + Vector2(255, 0.5)
		if(c_rooms.get(Vector2(0, 1)) != null):
			temp = Sprite2D.new()
			temp.texture = branch_sprite
			map_node.add_child(temp)
			temp.z_index = 0
			temp.rotation_degrees = 90
			temp.position = i * 514 + Vector2(0.5, 255)

func _physics_process(delta):
	if Input.is_action_just_pressed("Interact"):
		randomize()
		dungeon = DungeonGeneration.generate(randf_range(-1000, 1000))
		load_map()
	

