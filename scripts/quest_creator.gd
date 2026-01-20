class_name QuestCreator extends Node

@export var hud : Hud

var questDialogue : String
var itemDesc : String

var currentQuest : Quest


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
	
func CreateDialogue():
	var data = LoadJson("res://Pnjson/bete.json")
	var grammar = Tracery.Grammar.new(data)
	
	var rng = RandomNumberGenerator.new()
	grammar.rng = rng
	grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
	
	var sentence = grammar.flatten("#origin#")
	var sentenceAray = sentence.split(";")
	for i in grammar._save_data:
		print(i + grammar._save_data[i])
		
	
	hud.label.text = sentenceAray[0]
	hud.itemLabel.text = sentenceAray[1]

	var currentQuestItem: ItemData = ItemData.new(grammar._save_data["item"],
	grammar._save_data["indiceI1"], grammar._save_data["indiceI2"])

	currentQuest = Quest.new(currentQuestItem, sentenceAray[1], sentenceAray[0])
	print(sentence)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Dialogue"):
		CreateDialogue()
	if Input.is_action_just_pressed("Attack"):
		ItemGenerator.GenerateItem(ItemData.new("n","r","t"))
