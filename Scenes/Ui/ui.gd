extends CanvasLayer
class_name UI

@onready var ammo_label = %Ammo
@onready var weapon_manager = get_node("/root/Game/World/Player/WeaponManager")
@onready var weapon_texture = %WeaponSprite

var current_weapon

func _physics_process(delta):
	if(weapon_manager):
		current_weapon = weapon_manager.weapons[weapon_manager.selectedWeapon].get_node('Weapon')
		weapon_texture.texture = current_weapon.get_node('Sprite').texture
		if current_weapon.disable_ammo:
			ammo_label.text = '&'
		else:
			ammo_label.text = str(current_weapon.ammo)
