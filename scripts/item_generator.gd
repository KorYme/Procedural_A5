class_name ItemGenerator extends Node

@export var percentageOfRoomsWithItem : float = 0.3

static var itemDataBase: Dictionary
static var grammar

func GenerateItemBatch(bannedItem: ItemData) -> ItemData:
		
	itemDataBase = QuestCreator.LoadJson("res://Pnjson/ItemRandom.json")
	grammar = Tracery.Grammar.new(itemDataBase)
	var rng = RandomNumberGenerator.new()
	grammar.rng = rng
	grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
		
	print(grammar.flatten("#origin#"))
	
	var item : ItemData = null
	
	while item == null or ItemData.is_the_same(item, bannedItem):
		item = ItemData.new(grammar._save_data["item"], grammar._save_data["indiceQ1"]
		, grammar._save_data["indiceQ2"])
			
	return item
	
	
func DispatchItems(questItem : ItemData) -> void:
	var rooms : Array[Room] = Room.all_rooms
	
	var nbRoomToSpawnItems : int =  max(1, rooms.size() * percentageOfRoomsWithItem)
	
	for i in range(0, nbRoomToSpawnItems):
		var roomIndex : int = randi_range(0, rooms.size() - 1)
		var itemArray : Array[Node] = (rooms[roomIndex].get_tree().get_nodes_in_group("Items"))
		var selectedItemSlot : ItemCollectible = itemArray[randi_range(0, itemArray.size() - 1)]
		if i == 0:
			selectedItemSlot.setup(questItem)
		else:
			selectedItemSlot.setup(GenerateItemBatch(questItem))
	
	for i in get_tree().get_nodes_in_group("Items") as Array[ItemCollectible]:
		if(!i.isSettedUp):
			i.queue_free()
