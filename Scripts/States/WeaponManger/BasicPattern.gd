extends State
class_name BulletManagerBasic

@onready var bullet_manager: Node2D = $"../.."
@onready var shoot_timer: Timer = $"../../ShootTimer"

@export var attack_speed = 1.0
@export var bullet_speed = 200
@export var bullet_life_span = 10
@export var bullet_wobble_intensity = 0
@export var bullet_wobble_intensity_timer_duration = 0
@export var bullet_rotation_offset = 90
@export_range(0,0.3) var bullet_rotation_speed = 1

func Enter():	
	shoot_timer.start(attack_speed)

#func Physics_Update(delta: float):
	#bullet_manager._rotate(1, -1)
func Exit():
	shoot_timer.stop()
	print('test')


func _on_shoot_timer_timeout():
	var bullet_instance = bullet_manager.bullet.instantiate()
	
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
	
	shoot_timer.start(attack_speed)
