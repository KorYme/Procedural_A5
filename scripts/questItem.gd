class_name ItemData extends Resource
var type : String
var indice1 : String
var indice2 : String
var sprite : Sprite2D

static func is_the_same(item1 : ItemData, item2: ItemData) -> bool:
	return item1.type == item2.type && item1.indice1 == item2.indice1 && item1.indice2 == item2.indice2
	
func _init(_type: String, _indice1: String, _indice2: String):
	type = _type
	indice1 = _indice1
	indice2 = _indice2
	
	#match type:
	#	"epee":
	#		sprite.texture = 
	#TODO
