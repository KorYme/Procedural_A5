class_name RoomData extends Resource

enum RoomBiome
{
	Cemetary,
	Foreset,
	Swamp,
	Mountain,
	Desert,
}

@export var room_biome : RoomBiome

@export var room_shape : Array[Vector2i]

@export var room_reference : PackedScene
