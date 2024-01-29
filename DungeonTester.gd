extends Node2D

var dungeon = {}
var node_sprite = load("res://Sprites/map_nodes1.png")
var branch_sprite = load("res://Sprites/map_nodes3.png")
var room_variants = load("res://Scenes/room_variants.tscn")

@onready var map_node = $MapNode

func _ready():
	dungeon = DungeonGeneration.generate(533)
	load_map()

func load_map():
	for i in range(0, map_node.get_child_count()):
		map_node.get_child(i).queue_free()
		
	for i in dungeon:
		var temp = Sprite2D.new()
		temp.texture = node_sprite
		var room_instance = dungeon[i].room_scene.instantiate()
		var room = room_instance.get_child(dungeon[i].room_index)
		room.process_mode = 0 # = Mode: Inherit
		room.show()
		map_node.add_child(room_instance)
		room_instance.z_index = 1
		room_instance.position = i * 514
		var c_rooms = dungeon[i].connected_rooms
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
	

