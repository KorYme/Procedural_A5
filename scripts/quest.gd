class_name Quest extends Resource

var questItem : ItemData
var questDialogue : String
var itemDesc : String
var race : String
var pnjName : String

func _init(_questItem: ItemData, _questDialogue: String, _itemDesc: String, _race : String, _name : String):
	questItem = _questItem
	questDialogue = _questDialogue
	itemDesc = _itemDesc
	race = _race
	pnjName = _name
