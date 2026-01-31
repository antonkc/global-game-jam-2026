extends Node

@onready var main: Node2D = $main
@onready var credits: Node2D = $credits
@onready var settings: Node2D = $settings

@onready var others = [
	credits,
	settings,
]

func _on_draw() -> void:
	for other in others:
		FocusHelper.set_focused(other, false)
	FocusHelper.set_focused(main, true)


func _on_hidden() -> void:
	pass # Replace with function body.
