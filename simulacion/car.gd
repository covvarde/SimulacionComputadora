extends CharacterBody3D

@onready var car = %CAR

func _process(delta):
	velocity = transform.basis.z * 50
	
	move_and_slide()
