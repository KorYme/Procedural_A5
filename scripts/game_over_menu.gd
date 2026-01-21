extends CanvasLayer

@onready var respawn_button: Button = $RespawnButton

func _ready() -> void:
	respawn_button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	hide()
	# await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
	print("Reloaded scene")
