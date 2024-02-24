extends Node2D

var dungeon = {}
var node_sprite = load("res://Sprites/map_nodes1.png")
var branch_sprite = load("res://Sprites/map_nodes3.png")
var room_variants = load("res://Scenes/room_variants.tscn")
var hidden_room_variants = load("res://Scenes/hidden_rooms.tscn")
var playerScene = preload("res://Scenes/player.tscn")
var room_size = 1152

@onready var map_node = $MapNode
signal map_deleted

func on_player_instantiated():
	print('player instantiated')
	
func _ready():
	map_deleted.connect(on_map_deleted)
	SignalManager.player_instantiated.connect(on_player_instantiated)
	dungeon = DungeonGeneration.generate(533)
	load_map()
	
func on_map_deleted():
	randomize()
	dungeon = DungeonGeneration.generate(randf_range(-1000, 1000))
	load_map()

func load_map():	
	var player = playerScene.instantiate()
	map_node.add_child(player)
	await on_player_instantiated()
	
	for i in dungeon:
		if(dungeon[i].room.name == 'Hidden1'):
			var hidden_room_instance = hidden_room_variants.instantiate()
			var hidden_room = hidden_room_instance.get_node("Hidden1")
			hidden_room.generate_doors(dungeon[i].connected_rooms, hidden_room.hidden_doors)
			hidden_room.process_mode = 0 # = Mode: Inherit
			hidden_room.show()
			map_node.add_child(hidden_room_instance)
			hidden_room_instance.z_index = 1
			hidden_room_instance.position = i * room_size
			
		if(dungeon[i].type == 'start'):
			player.position = i * room_size
			player.z_index = 1000
			var start_room = dungeon[i].start_room
			start_room.generate_doors(dungeon[i].connected_rooms, dungeon[i].room.hidden_doors)
			start_room.process_mode = 0 # = Mode: Inherit
			start_room.show()
			map_node.add_child(start_room)
			start_room.z_index = 1
			start_room.position = i * room_size

		if(dungeon[i].type == 'end'):
			var end_room = dungeon[i].end_room
			end_room.generate_doors(dungeon[i].connected_rooms, dungeon[i].room.hidden_doors)
			end_room.process_mode = 0 # = Mode: Inherit
			end_room.show()
			map_node.add_child(end_room)
			end_room.z_index = 1
			end_room.position = i * room_size
		elif dungeon[i].type == 'basic':
			var room = dungeon[i].chosen_variation
			room.generate_doors(dungeon[i].connected_rooms, dungeon[i].room.hidden_doors)
			room.process_mode = 0 # = Mode: Inherit
			room.show()
			map_node.add_child(room)
			room.z_index = 1
			room.position = i * room_size
		var c_rooms = dungeon[i].connected_rooms
		var temp = Sprite2D.new()
		temp.texture = node_sprite
		if(c_rooms.get(Vector2(1, 0)) != null):
			temp = Sprite2D.new()
			temp.texture = branch_sprite
			map_node.add_child(temp)
			temp.z_index = 0
			temp.position = i * room_size + Vector2(room_size / 2, 0.5)
		if(c_rooms.get(Vector2(0, 1)) != null):
			temp = Sprite2D.new()
			temp.texture = branch_sprite
			map_node.add_child(temp)
			temp.z_index = 0
			temp.rotation_degrees = 90
			temp.position = i * room_size + Vector2(0.5, room_size / 2)

func _physics_process(delta):
	if Input.is_action_just_pressed("Interact"):
		for child in map_node.get_children():
			map_node.remove_child(child)
			child.queue_free()
			
		emit_signal("map_deleted")
	

