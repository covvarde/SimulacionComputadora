extends Node3D

@onready var car = preload("res://car.tscn")
@onready var spawn_pos = $SpawnPos

func _on_spawn_delay_timeout() -> void:
	var car_instance = car.instantiate()
	car_instance.position = spawn_pos.position
	add_child(car_instance)
