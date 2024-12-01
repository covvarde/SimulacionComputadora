extends CharacterBody3D

@export_group ("Movement")
@export var speed = 20
@export var jump_velocity = 4.5
@export var rotation_speed := 12.0

@onready var pivot = %CameraPivot
@onready var camera = %Camera3D
@onready var skin = %Bicycle

const SENSITIVITY = 0.003
var gravity = 9.8
var _last_movement_direction := Vector3.BACK

func _input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _unhandled_input(event):
	var is_camera_motion := (event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	
	if is_camera_motion:
		pivot.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (pivot.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	move_and_slide()
	
	if direction.length() > 0.2:
		_last_movement_direction = direction
		
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	skin.global_rotation.y = lerp(skin.rotation.y, target_angle, rotation_speed * delta)
	

func _on_collision_body_entered(body: Node3D) -> void:
	if body.is_in_group("Cars"):
		get_tree().reload_current_scene()
