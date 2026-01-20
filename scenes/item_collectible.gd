class_name ItemCollectible extends CollectibleBase

var data : ItemData

func _init(_data: ItemData):
	data = _data
	

func on_collect() -> void:
	super()
	#Ptet mettre un signal ou jsp je suis pas godeur
	
