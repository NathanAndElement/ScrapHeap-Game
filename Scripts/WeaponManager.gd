extends Node2D

@onready var weapons = []
@onready var num_of_weapons = 0;

@onready var selectedWeapon = 0

func _ready():
	await calculate_weapon_tree()
	select_weapon(weapons[0])

func calculate_weapon_tree():
	weapons = []
	for weapon in get_node("Weapons").get_children():
		weapons.push_back(weapon)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Weapon Up") and selectedWeapon < weapons.size() - 1:
		disable_weapon(weapons[selectedWeapon])
		selectedWeapon +=1
		select_weapon(weapons[selectedWeapon])

	if Input.is_action_just_pressed("Weapon Down") and selectedWeapon > 0:
		disable_weapon(weapons[selectedWeapon])
		selectedWeapon -= 1
		select_weapon(weapons[selectedWeapon])

func disable_weapon(node:Node) -> void:
	node.process_mode = 4 # = Mode: Disabled
	node.hide()

func select_weapon(node: Node2D) -> void:
	node.process_mode = 0 # = Mode: Inherit
	node.show()

func _on_weapons_child_entered_tree(node):
	if weapons:
		await calculate_weapon_tree()
		disable_weapon(weapons[selectedWeapon])
		selectedWeapon = weapons.size() - 1
		select_weapon(weapons[selectedWeapon])
