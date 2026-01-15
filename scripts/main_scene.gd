class_name main_scene extends Node2D

@export var room_data : Array[RoomData]

const room_size : Vector2i = Vector2i( 352, -288 )

func _ready() -> void:
	generate_dungeons()
	pass

func generate_dungeons(size : int = 5) -> void:
	# Fill the tab
	var tab : Array[Array] = []
	var sub_tab : Array[int] = []
	for i in range(size):
		sub_tab.append(false)
	for i in range(size):
		tab.append(sub_tab.duplicate(true))
		
	var room_number : int = size * size * 0.8
	for i in range(room_number):
		
		pass
		
	
	for x in range(size):
		for y in range(size):
			if tab[x][y]:
				continue
			var instance = room_data.pick_random().instantiate()
			instance.position.x = x * room_size.x
			instance.position.y = y * room_size.y
			add_child(instance)
			pass
