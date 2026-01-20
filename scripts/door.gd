class_name Door extends Node2D

enum STATE {OPEN = 0, CLOSED = 1, WALL = 2}

@export var closedNode : Node2D
@export var openNode : Node2D

var state : STATE

var connected_door : Door
signal door_state_changed(new_value : STATE)

var _room : Room

@onready var door_collision = $"DoorCollision"
@onready var other_door_raycast = $"DoorArea2D"


func _ready() -> void:
	var node = self
	while (node != null && !node is Room):
		node = node.get_parent()

	if node == null:
		push_error(node == null, "The door is not in any room")
		return

	_room = node
	_room.doors.push_back(self)


func try_unlock() -> void:
	if state != STATE.CLOSED || Player.Instance.key_count <= 0:
		return

	Player.Instance.key_count -= 1
	set_state(STATE.OPEN)


func setup() -> void:
	var otherAreas : Array[Area2D] = other_door_raycast.get_overlapping_areas()
	set_state_manually(STATE.WALL)
	connected_door = null
	for area in otherAreas:
		var parent = area.get_parent()
		if parent is Door:
			connected_door = parent
			connected_door.door_state_changed.connect(set_state_manually)
			return

func set_state(new_state : STATE) -> void:
	set_state_manually(new_state)
	door_state_changed.emit(state)
	
func set_state_manually(new_state : STATE) -> void:
	closedNode.visible = false
	openNode.visible = false

	state = new_state
	match state:
		STATE.CLOSED, STATE.WALL:
			closedNode.visible = true
			door_collision.set_deferred("disabled", false)
		STATE.OPEN:
			openNode.visible = true
			door_collision.set_deferred("disabled", true)


func _exit_tree() -> void:
	for dict in door_state_changed.get_connections():
		door_state_changed.disconnect(dict.callable)
