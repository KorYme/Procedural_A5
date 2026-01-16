extends Node2D

@export var weapon_type: Player.WEAPON

var is_player_in_range : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if Player.Instance == null:
		return
	
	if body != Player.Instance:
		return
		
	is_player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if Player.Instance == null:
		return
	
	if body != Player.Instance:
		return 
		
	is_player_in_range = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and is_player_in_range:
		Player.Instance.swap_weapon(weapon_type)
		queue_free()
