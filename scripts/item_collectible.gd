class_name ItemCollectible extends CollectibleBase

signal collected(data: ItemData)
@export var sprite : Sprite2D
var _data : ItemData
var isSettedUp : bool

func _ready() -> void:
	var hud : Hud = get_tree().root.get_node("MainScene/hud")
	collected.connect(hud.on_collect_data)
	on_collect()

func setup(data: ItemData):
	sprite.texture = data.sprite
	_data = data
	isSettedUp = true


func on_collect() -> void:
	super()
	collected.emit(_data)
