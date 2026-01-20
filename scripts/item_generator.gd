class_name ItemGenerator extends Node

static var itemDataBase: Dictionary
static var grammar

static func GenerateItem(bannedItem: ItemData) -> ItemData:
	if itemDataBase.is_empty():
		itemDataBase = QuestCreator.LoadJson("res://Pnjson/ItemRandom.json")
		grammar = Tracery.Grammar.new(itemDataBase)
		var rng = RandomNumberGenerator.new()
		grammar.rng = rng
		grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
		
	grammar.flatten("#origin#")
	
	var item : ItemData = null
	for i in grammar._save_data:
		print(i)
	while item == null or ItemData.is_the_same(item, bannedItem):
		item = ItemData.new(grammar._save_data["item"], grammar._save_data["indiceQ1"]
		, grammar._save_data["indiceQ2"])
		
	return item
	
