class_name ItemGenerator extends Node

static var itemDataBase: Dictionary
static var grammar

static func GenerateItemBatch(bannedItem: ItemData, itemCount: int) -> Array[ItemData]:
	var result : Array[ItemData]
	
	itemDataBase = QuestCreator.LoadJson("res://Pnjson/ItemRandom.json")
	grammar = Tracery.Grammar.new(itemDataBase)
	var rng = RandomNumberGenerator.new()
	grammar.rng = rng
	grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
		
	print("-----------------")
	print(grammar.flatten("#origin#"))
	
	var item : ItemData = null
	
	for i in range(0, itemCount):
		item = ItemData.new(grammar._save_data["item"], grammar._save_data["indiceQ1"]
			, grammar._save_data["indiceQ2"])
		while ItemData.is_the_same(item, bannedItem):
			item = ItemData.new(grammar._save_data["item"], grammar._save_data["indiceQ1"]
			, grammar._save_data["indiceQ2"])
		result.push_back(item)
			
		
	return result
	
