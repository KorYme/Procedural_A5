class_name Quest extends Resource

var questItem : ItemData
var questDialogue : String
var itemDesc : String

func _init(_questItem: ItemData, _questDialogue: String, _itemDesc: String):
	questItem = _questItem
	questDialogue = _questDialogue
	itemDesc = _itemDesc
