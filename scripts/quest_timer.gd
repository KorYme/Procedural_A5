extends Node

@export var timer_duration: float

@export var timer_label: Label
@export var timer: Node

func _ready() -> void:
	timer.wait_time = timer_duration
	timer.one_shot = true
	timer.timeout.connect(_on_timer_finished)
	add_child(timer)
	timer.start()
	
func _process(_delta):
	if timer.time_left > 0:
		timer_label.text = "Time: %.1f" % timer.time_left
	
func _on_timer_finished() -> void:
	# trigger quest failure event here
	print("Quest timer finished!")
