extends CharacterBody2D

@export var speed = 50
@export var nav_agent: NavigationAgent2D
@export var health = 100
@export var damage = 20

func _physics_process(_delta):
	if health <= 0:
		kill_unit()

func kill_unit():
	queue_free()

func _on_collision_area_entered(area):
	#Bullet damage
	if area.name == "BulletArea":
		var bullet = area.get_parent()
		health -= bullet.damage
		bullet.queue_free()
		
	#Damage player
	if area.name == "DamageArea":
		var player = area.get_parent()
		player.colliding_enemies.append(self)

func _on_collision_area_area_exited(area):
	if area.name == "DamageArea":
		var player = area.get_parent()
		player.colliding_enemies.remove_at(player.colliding_enemies.find(self))
