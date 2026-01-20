class_name ItemData extends Resource
var type : String
var indice1 : String
var indice2 : String
var sprite : Texture2D

static func is_the_same(item1 : ItemData, item2: ItemData) -> bool:
	if item1 == null or item2 == null:
		return false
	return item1.type == item2.type && item1.indice1 == item2.indice1 && item1.indice2 == item2.indice2
	
func _init(_type: String, _indice1: String, _indice2: String):
	type = _type
	indice1 = _indice1
	indice2 = _indice2
	
	match type:
		"epee":
			sprite = load("res://sprites/Tiles/Colored/tile_0070.png")
		"masse":
			sprite = load("res://sprites/Tiles/Colored/tile_0058.png")
		"lance":
			sprite = load("res://sprites/Tiles/Colored/tile_0074.png")
		"hache":
			sprite = load("res://sprites/Tiles/Colored/tile_0071.png")
