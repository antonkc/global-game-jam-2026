class_name DialogData

var dialog_name: String = ""
var prop_set: String = ""
var dialog: Array[DialogItemData] = []

func _init()->void:
	pass

func close()->void:
	for d in dialog:
		d.close()
	free()
