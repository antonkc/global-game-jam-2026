class_name GameState

var location: String = "tutorial"
var effects: Array[String] = []

func _init()->void:
	pass

func close()->void:
	free()

func has_effect(eff_name: String)->bool:
	for eff in effects:
		if eff_name == eff:
			return true
	return false
