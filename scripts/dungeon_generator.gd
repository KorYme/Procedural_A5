class_name DungeonGenerator extends Node2D

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

	var first_room_pos : Vector2i = Vector2i(size / 2, 0)
	@warning_ignore("narrowing_conversion")
	var room_number : int = size * size * 0.5
	@warning_ignore("integer_division")
	var coordinates : Array[Vector2i] = [first_room_pos]
	@warning_ignore("integer_division")
	tab[0][size / 2] = true
	
	for i in range(room_number - 1):
		coordinates.shuffle()
		var index : int = coordinates.find_custom(
			func(value): 
			return has_empty_box_near(tab, value) == 1
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
				var tmp_rooms : Array[RoomData] = room_data.Rooms.filter(
					func(roomData):
					return check_room_fit_in(roomData, tmp_fill_tab, Vector2i(x, y)) and roomData.room_biome == biome
				)
				var tmp_room : RoomData = tmp_rooms.pick_random()
				var is_first_room : bool = first_room_pos.x == x and first_room_pos.y == y
				tmp_fill_tab[y][x] = false
				for dir in tmp_room.room_shape:
					is_first_room = is_first_room or (first_room_pos.x == x + dir.x and first_room_pos.y == y + dir.y)
					tmp_fill_tab[y + dir.y][x + dir.x] = false
				
				var instance = tmp_room.room_reference.instantiate()
				@warning_ignore("integer_division")
				instance.position.x = (x - size / 2) * room_data.RoomSize.x
				instance.position.y = -y * room_data.RoomSize.y
				add_child(instance)
				##TMP
				#if is_first_room:
					#if instance is Room:
						#Player.Instance.enter_room(instance)
					#else:
						#print(instance.name)
				
	for room in Room.all_rooms:
		for door in room.doors:
			door.setup()

# 0 is false, 1 is true, -1 is out of bounds
func check_coordinates(tab : Array[Array], value : Vector2i) -> int:
	var size_y : int = tab.size()
	if size_y <= 0:
		return -1
	var size_x : int = tab[0].size()
	if size_x < 0:
		return -1
	if value.x >= size_x or value.y >= size_y or value.x < 0 or value.y < 0:
		return -1
	return tab[value.y][value.x]

# 0 is false, 1 is true, -1 is out of bounds
func has_empty_box_near(tab : Array[Array], value : Vector2i) -> int:
	var size_y : int = tab.size()
	if size_y <= 0:
		return -1
	var size_x : int = tab[0].size()
	if size_x < 0:
		return -1
	if value.x >= size_x or value.y >= size_y or value.x < 0 or value.y < 0:
		return -1
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
		if check_coordinates(tab, origin + dir) != 1:
			return false
	return true
