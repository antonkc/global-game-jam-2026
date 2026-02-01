class_name DialogItemData

var text: String = ""
var speaker_name: String = ""
var speaker: String = ""
var cond: Array[String] = []
var resp: Array[DialogItemResponse] = []

func _init()->void:
	pass

func close()->void:
	for r in resp:
		r.close()
	free()
