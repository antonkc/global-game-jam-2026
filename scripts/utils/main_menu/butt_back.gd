extends Node

@onready var main: Node2D = $"../../main"
@onready var credits: Node2D = $"../../credits"

@export var input_names: Array[String] = []
@export var is_input_focused: bool = false
var mouse_on: bool = false

func action()->void:
	main.show()
	FocusHelper.set_focused(main, true)
	credits.hide()
	FocusHelper.set_focused(credits, false)

func _input(event: InputEvent) -> void:
	if !is_input_focused:
		return
	if event is InputEventMouseButton && mouse_on && event.is_action_released("click", true):
		action()
	for input_name in input_names:
		if event.is_action(input_name, true):
			action()

func _on_mouse_entered():
	mouse_on = true

func _on_mouse_exited():
	mouse_on = false
