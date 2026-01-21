class_name Hud extends CanvasLayer

@export var heart_scene : PackedScene
@export var label : Label
@export var itemLabel : Label

var previous_life : int

@onready var life_container : BoxContainer = $"LifeContainer"

#Item desc
@export var itemFoundSprite : Sprite2D
@export var itemFoundDesc : Label
@export var UiDescItems : Array[Node]




func _ready() -> void:
	previous_life = Player.Instance.life
	Player.Instance.life_changed.connect(_on_life_changed)
	for heart in previous_life:
		_add_heart()


func _on_life_changed(new_life : int) -> void:
	if new_life < previous_life:
		_remove_heart()
	elif new_life > previous_life:
		_add_heart()


func _add_heart() -> void:
	var heart = heart_scene.instantiate()
	life_container.add_child(heart)


func _remove_heart() -> void:
	if life_container.get_child_count() == 0:
		return

	var heart =	life_container.get_child(0)
	life_container.remove_child(heart)
	
func on_collect_data(data: ItemData) -> void:
	
	for i in UiDescItems:
		i.visible = true
		
	itemFoundSprite.texture = data.sprite
	itemFoundDesc.text = data.type + " " + data.indice1 + " " + data.indice2
	
	await get_tree().create_timer(4.0).timeout
	for i in UiDescItems:
		i.visible = false
		
	pass
