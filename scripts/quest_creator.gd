class_name QuestCreator extends Node

@export var hud : Hud

var questDialogue : String
var itemDesc : String


func LoadJson(path: String) -> Dictionary:
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
	var data = LoadJson("res://test.json")
	var grammar = Tracery.Grammar.new(data)
	
	var rng = RandomNumberGenerator.new()
	grammar.rng = rng
	grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
	
	var sentence = grammar.flatten("#origin#")
	var sentenceAray = sentence.split(";")
	
	hud.label.text = sentenceAray[1]
	hud.itemLabel.text = sentenceAray[2]
	print(sentence)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Dialogue"):
		CreateDialogue()
