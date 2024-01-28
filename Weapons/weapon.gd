extends CharacterBody2D

@export var bullet_scene_path: String
@export var weapon_scene: String
@export var damage: float = 50
@export var ammo = 5
@export var disable_ammo: bool = true
@export var attack_speed: float = .2
@export var mag_size = 10 
@export var disable_reload: bool
@export var reload_time = 1
@export var bullet_speed = 400
@export var bullet_scale: Vector2

@onready var bullet = load(bullet_scene_path)
@onready var shoot_timer: Timer = $ShootTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var current_mag_size = mag_size
@onready var is_held = false
@onready var colliding = false
@onready var weapons = null

var can_shoot = true
var reloading = false

func _ready():
	weapons = get_node("/root/Game/World/Player/WeaponManager/Weapons")
	
	var sprite = get_node("Sprite")
	if get_parent().get_parent().get_parent().name == 'WeaponManager':
		is_held = true

	
	
func _physics_process(delta):
	if(is_held):
		look_at(get_global_mouse_position())
		#Reload logic
		if current_mag_size <= 0 and not reloading and not disable_reload:
			reloading = true
			reload_timer.start(reload_time)
		#Shoot logic
		if Input.get_action_strength("shoot"): 
			if can_shoot and current_mag_size > 0:
				if  ammo > 0 || disable_ammo:
					shoot()
					if not disable_reload: current_mag_size -= 1
					can_shoot = false
					shoot_timer.start(attack_speed)
	else:
		pick_up_weapon()

func pick_up_weapon():
	if(!is_held):
		if Input.is_action_just_pressed("Interact") and colliding:
			var weapon = load(weapon_scene).instantiate()
			
			weapon.visible = false
			weapon.process_mode = 4
			weapons.add_child(weapon)
			queue_free()
			

func shoot():
	if(is_held):
		var bullet_instance = bullet.instantiate()
		var bullets = get_tree().get_root()
		var barrel = get_node("Barrel")
		
		ammo -= 1;
		
		bullet_instance.damage = damage
		bullet_instance.position = barrel.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.scale = bullet_scale
		var bullet_direction = Vector2(bullet_speed, 0).rotated(rotation)
		bullet_instance.set_linear_velocity(bullet_direction)  # Set the bullet's initial velocity
		bullets.call_deferred("add_child", bullet_instance)
	
	
#Attack speed timer
func _on_timer_timeout():
	if(is_held):
		can_shoot = true
		shoot_timer.stop()

#Reload timer
func _on_reload_timer_timeout():
	if(is_held):
		current_mag_size = mag_size
		reloading = false
		reload_timer.stop()
	


func _on_area_2d_area_entered(area):
	colliding = true


func _on_area_2d_area_exited(area):
	colliding = false



