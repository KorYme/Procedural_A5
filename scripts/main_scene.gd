class_name main_scene extends Node2D

@export var room_data : AllRoomData

var directions : Array[Vector2i] = [Vector2i( 1, 0 ), Vector2i( -1, 0 ), 
Vector2i( 0, 1 ), Vector2i( 0, -1 )]

func _ready() -> void:
	generate_dungeons()
	pass

func generate_dungeons(size : int = 5) -> void:
	# Fill the tab
	var tab : Array[Array] = []
	var sub_tab : Array[bool] = []
	for i in range(size):
		sub_tab.append(false)
	for i in range(size):
		tab.append(sub_tab.duplicate(true))

	var room_number : int = size * size * 0.5
	var coordinates : Array[Vector2i] = [Vector2i(size / 2, 0)]
	tab[0][size / 2] = true
	
	for i in range(room_number - 1):
		coordinates.shuffle()
		var index : int = coordinates.find_custom(
			func(value): 
			return (
			(value.y + 1 < size and !tab[value.y + 1][value.x]) or
			(value.y - 1 >= 0 and !tab[value.y - 1][value.x]) or
			(value.x + 1 < size and !tab[value.y][value.x + 1]) or 
			(value.x - 1 >= 0 and !tab[value.y][value.x - 1])
			))
		var pos : Vector2i = coordinates[index]
		
		directions.shuffle()
		for dir in directions:
			if (dir.x + pos.x >= 0 and dir.x + pos.x < size 
			and dir.y + pos.y >= 0 and dir.y + pos.y < size 
			and !tab[dir.y + pos.y][dir.x + pos.x]):
				tab[dir.y + pos.y][dir.x + pos.x] = true
				coordinates.append(Vector2i(dir.x + pos.x, dir.y + pos.y))
				break
		
	for x in range(size):
		for y in range(size):
			if tab[y][x]:
				var instance = room_data.Rooms.pick_random().room_reference.instantiate()
				instance.position.x = (x - size / 2) * room_data.RoomSize.x
				instance.position.y = -y * room_data.RoomSize.y
				add_child(instance)
				if instance is Room:
					#instance.doors
					pass
