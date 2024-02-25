extends State
class_name BulletManagerBasic

@onready var bullet_manager: Node2D = $"../.."
@onready var shoot_timer: Timer = $"../../ShootTimer"
@onready var reload_timer: Timer = $"../../ReloadTimer"

@export var attack_speed = 1.0
@export var bullet_speed = 200
@export var bullet_life_span = 10
@export var bullet_wobble_intensity = 0
@export var bullet_wobble_intensity_timer_duration = 0
@export var bullet_rotation_offset = 90
@export var reload_speed = 1.0
@export var mag_size = 6
var is_reloading = false

@export_range(0,0.3) var bullet_rotation_speed = 1

var current_mag_count = mag_size

func Enter():	
	shoot_timer.start(attack_speed)

#func Physics_Update(delta: float):
	#bullet_manager._rotate(1, -1)
func Exit():
	shoot_timer.stop()


func _on_shoot_timer_timeout():
	if(current_mag_count <= 0):
		is_reloading = true
		shoot_timer.stop()
		reload_timer.start(reload_speed)
	else:
		var bullet_instance = bullet_manager.bullet.instantiate()
	
		bullet_instance.z_index = 10
		bullet_instance.speed = bullet_speed
		bullet_instance.life_span = bullet_life_span
		bullet_instance.wobble_intensity = bullet_wobble_intensity
		bullet_instance.wobble_intensity_timer_duration = bullet_wobble_intensity_timer_duration
		bullet_instance.rotation_offset = bullet_rotation_offset
		bullet_instance.rotation_speed = bullet_rotation_speed
	
		var bullets = get_tree().get_root()
		bullet_instance.rotation_degrees = bullet_manager.rotation_degrees
		bullet_instance.position = bullet_manager.get_global_position()
		bullets.call_deferred("add_child", bullet_instance)
	
		current_mag_count -= 1
	
		shoot_timer.start(attack_speed)


func _on_reload_timer_timeout():
	is_reloading = false
	current_mag_count = mag_size
	shoot_timer.start()
