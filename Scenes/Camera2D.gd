extends Camera2D

@export var pan_range = 60
@onready var camera_pan_speed = 0.2
@onready var target = $".."  # Assuming you have a valid path here

func _physics_process(delta):
	# Camera movement
	var mouse_position = get_global_mouse_position()
	var centre_position = target.global_position
	
	var offset_difference = centre_position - mouse_position
	
	# Calculate the new position using lerp
	var new_position = lerp(position, Vector2(-offset_difference.x / 8, -offset_difference.y / 8), camera_pan_speed)
	
	# Check if the new position is outside the circular range, and if so, normalize it
	if new_position.length() > pan_range:
		new_position = new_position.normalized() * pan_range
	
	# Assign the position back to the camera
	position = new_position
