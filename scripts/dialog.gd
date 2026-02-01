extends Node2D
class_name Dialog

@onready var dialogo: Panel = $dialogo
@onready var screen: Panel = $screen
@onready var facecam: Panel = $facecam

func load_dialog(data: DialogData, effects: Array[String])-> void:
	pass
