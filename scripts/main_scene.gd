class_name main_scene extends Node2D

@export var room_data : AllRoomData

var directions : Array[Vector2i] = [Vector2i( 1, 0 ), Vector2i( -1, 0 ), 
Vector2i( 0, 1 ), Vector2i( 0, -1 )]

func _ready() -> void:
	generate_dungeons()
	pass

func generate_dungeons(size : int = 5, biome : RoomData.RoomBiome = RoomData.RoomBiome.Cemetary) -> void:
	# Fill the tab
	var tab : Array[Array] = []
	var sub_tab : Array[bool] = []
	for i in range(size):
		sub_tab.append(false)
	for i in range(size):
		tab.append(sub_tab.duplicate(true))

	@warning_ignore("narrowing_conversion")
	var room_number : int = size * size * 0.5
	@warning_ignore("integer_division")
	var coordinates : Array[Vector2i] = [Vector2i(size / 2, 0)]
	@warning_ignore("integer_division")
	tab[0][size / 2] = true
	
	for i in range(room_number - 1):
		coordinates.shuffle()
		var index : int = coordinates.find_custom(
			func(value): 
			return check_coordinates(tab, value) == 0
			)
		var pos : Vector2i = coordinates[index]
		
		directions.shuffle()
		for dir in directions:
			if (dir.x + pos.x >= 0 and dir.x + pos.x < size 
			and dir.y + pos.y >= 0 and dir.y + pos.y < size 
			and !tab[dir.y + pos.y][dir.x + pos.x]):
				tab[dir.y + pos.y][dir.x + pos.x] = true
				coordinates.append(Vector2i(dir.x + pos.x, dir.y + pos.y))
				break
		
	var tmp_fill_tab : Array[Array] = tab.duplicate_deep(true)
	for x in range(size):
		for y in range(size):
			if tmp_fill_tab[y][x]:
				var tmp_room : RoomData = room_data.Rooms.filter(
					func(roomData):
					return check_room_fit_in(roomData, tmp_fill_tab, Vector2i(x, y)) and roomData.room_biome == biome
				).pick_random()
				tmp_fill_tab[y][x] = false
				for dir in tmp_room.room_shape:
					tmp_fill_tab[y + dir.y][x + dir.x] = false
				
				var instance = tmp_room.room_reference.instantiate()
				@warning_ignore("integer_division")
				instance.position.x = (x - size / 2) * room_data.RoomSize.x
				instance.position.y = -y * room_data.RoomSize.y
				add_child(instance)
				
	for room in Room.all_rooms:
		pass

# 0 is false, 1 is true, 2 is out of bounds
func check_coordinates(tab : Array[Array], value : Vector2i) -> int:
	var size_y : int = tab.size()
	if size_y <= 0:
		return 2
	var size_x : int = tab[0].size()
	if size_x < 0:
		return 2
	if value.x >= size_x or value.y >= size_y or value.x < 0 or value.y < 0:
		return 2
	if value.y + 1 < size_y and tab[value.y + 1][value.x]: 
		return 1
	if value.y - 1 >= 0 and tab[value.y - 1][value.x]:
		return 1
	if value.x + 1 < size_x and tab[value.y][value.x + 1]:
		return 1
	if value.x - 1 >= 0 and tab[value.y][value.x - 1]:
		return 1
	return 0

func check_room_fit_in(room : RoomData, tab : Array[Array], origin : Vector2i) -> bool:
	for dir in room.room_shape:
		if check_coordinates(tab, origin + dir) == 0:
			return false
	return true
