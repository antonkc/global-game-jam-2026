extends Node2D
class_name Dialog

const prop_sets: Dictionary[String, PackedScene] = {
}

var entry_idx: int = 0
var data: DialogData = null

@onready var root: Dialog = $"."
@onready var dialogo: RichTextLabel = $dialogo/RichTextLabel
@onready var screen: Panel = $screen
@onready var facecam: Panel = $facecam

func load_dialog(data: DialogData, effects: Array[String])-> void:
	if data == null:
		printerr("tried to load null dialog")
		return
	print_debug("starting load for dialog \"%s\"" % data.dialog_name)
	entry_idx = 0
	if data.prop_set != "":
		if !_is_valid_dialog_prop(data.prop_set):
			printerr("an invalid prop_set was declared \"%s\"" % data.prop_set)
		else:
			#TODO: load prop_set
			pass
	_next(false)

func _input(event: InputEvent) -> void:
	if !root.visible:
		return
	if event.is_action_released("continue", true):
		_next(false)
	if event.is_action_released("sure_continue", true):
		_next(true)

func _next(can_exit: bool)->void:
	if !root.visible:
		return
	if len(data.dialog) <= entry_idx:
		if can_exit:
			var location: Location = find_parent("Location")
			data.close()
			dialogo.text = ""
			location.end_dialog()
		return
	
	var curr_entry: DialogItemData = data.dialog[entry_idx]
	var text: String = tr(curr_entry.text)
	
	dialogo.append_text("{name}: {content}\n".format({
		"name": curr_entry.speaker_name,
		"content": text,
	}))

func _is_valid_dialog_prop(prop_set: String)->bool:
	for p in prop_sets.keys():
		if prop_set == p:
			return true
	return false
