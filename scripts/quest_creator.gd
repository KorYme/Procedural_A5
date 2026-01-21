class_name QuestCreator extends Node

@export var hud : Hud
@export var itemGenerator : ItemGenerator

var questDialogue : String
var itemDesc : String
@export var itemsBatch : Array[ItemData]

var currentQuest : Quest

var races = ["bete", "elfe", "fantome", "hommearbre", "nain"]

static func LoadJson(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Eh gros le Json y pu la merde")
		return {}
		
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var result = json.parse(content)
	
	if result != OK:
		push_error("C'est pas ok")
		return {}
			
	return json.data
	
func CreateQuest():
	var race = races[randi_range(0, races.size() - 1)]
	var data = LoadJson("res://Pnjson/"+race+".json")
	var grammar = Tracery.Grammar.new(data)
	
	var rng = RandomNumberGenerator.new()
	grammar.rng = rng
	grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
	
	var sentence = grammar.flatten("#origin#")
	var sentenceAray = sentence.split(";")
	for i in grammar._save_data:
		print(i + grammar._save_data[i])
		
	
	hud.label.text = sentenceAray[1]
	hud.itemLabel.text = sentenceAray[2]

	var currentQuestItem: ItemData = ItemData.new(grammar._save_data["item"],
	grammar._save_data["indiceI1"], grammar._save_data["indiceI2"])

	currentQuest = Quest.new(currentQuestItem, sentenceAray[2], sentenceAray[1], race, sentenceAray[0])
	
	itemGenerator.DispatchItems(currentQuestItem)
	
	hud.toggleDialogueBox(true)
	hud.itemFoundSprite.texture = load("res://sprites/Tiles/Colored/tile_0006.png")
	hud.itemFoundDesc.text = currentQuest.questDialogue
	
	hud.clue1.text = currentQuest.questItem.type + "\n" + currentQuest.questItem.indice1
	hud.clue2.text = currentQuest.questItem.indice2
	
	await get_tree().create_timer(6.0).timeout
	hud.toggleDialogueBox(false)
	
	print("Quest created")
	 
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Dialogue"):
		CreateQuest()
