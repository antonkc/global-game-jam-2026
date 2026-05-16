extends Control
@onready var start_theatre: Control = $".."

@onready var parent: Location = start_theatre.find_parent("Location")

func _on_continue() -> void:
	parent.load_location("atropello")

func on_continue() -> void:
	_on_continue()
