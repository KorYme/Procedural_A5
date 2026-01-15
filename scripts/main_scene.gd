class_name main_scene extends Node2D

@export var base_rooms : Array[PackedScene]

func _ready() -> void:
	var instance = base_rooms.pick_random().instantiate()
	instance.position.x = 0
	instance.position.y = 0
	add_child(instance)
