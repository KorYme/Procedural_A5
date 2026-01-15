class_name QuestCreator extends Node


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
	
func _ready():
	var data = LoadJson("res://mescouilles.json")
	var grammar = Tracery.Grammar.new(data)
	
	var rng = RandomNumberGenerator.new()
	grammar.rng = rng
	grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
	
	for i in range (0,5):
		var sentence = grammar.flatten("#origin#")
		print(sentence)
