class_name QuestCreator extends Node

@export var text : Hud

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
	var data = LoadJson("res://mescouilles.json")
	var grammar = Tracery.Grammar.new(data)
	
	var rng = RandomNumberGenerator.new()
	grammar.rng = rng
	grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
	
	for i in range (0,5):
		var sentence = grammar.flatten("#origin#")
		text.label.text = sentence
		print(sentence)
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Dialogue"):
		CreateDialogue()
