extends Node2D
@onready var start_theatre: Node2D = $".."

var parent : Location = start_theatre.find_parent("Location")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_continue() -> void:
	parent.load_location("atropello")

func on_continue() -> void:
	_on_continue()	
