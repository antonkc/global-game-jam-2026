extends Node2D
class_name Dialog

const prop_sets: Dictionary[String, PackedScene] = {
}

@export var char_speed: float = 25.0

var entry_idx: int = 0
var data: DialogData = null
var is_choice_mode_enabled: bool = false
var active_choices: Array[DialogItemResponse] = []
var effects: Array[String] = []

@onready var root: Dialog = $"."
@onready var controller: Location = $".".find_parent("location")
@onready var dialogo: RichTextLabel = $dialog_log/RichTextLabel
@onready var screen: Panel = $screen
@onready var facecam: Panel = $facecam
@onready var speech_bubble_bg: ColorRect = $speech_bubble/ColorRect
@onready var speech_bubble: RichTextLabel = $speech_bubble/RichTextLabel

func load_dialog(in_data: DialogData, in_effects: Array[String])-> void:
	if in_data == null:
		printerr("tried to load null dialog")
		return
	print_debug("starting load for dialog \"%s\"" % in_data.dialog_name)
	data = in_data
	entry_idx = 0
	effects = in_effects.duplicate()
	if in_data.prop_set != "":
		if !_is_valid_dialog_prop(in_data.prop_set):
			printerr("an invalid prop_set was declared \"%s\"" % in_data.prop_set)
		else:
			#TODO: load prop_set
			pass
	_next(false)
func select_choice(i: int)->void:
	if len(active_choices) >= i || i < 0:
		printerr("tried to select invalid choice %s" % i)
		return

	var choice = active_choices[i]
	_add_log_text("Ali", tr(choice.text))
	is_choice_mode_enabled = false

	var options: Array[Node] = screen.find_children("option_*")
	for option in options:
		if option is Node2D:
			option.hide()

	_next(false)

func _input(event: InputEvent) -> void:
	if !root.visible:
		return
	if event.is_action_released("continue", true):
		_next(false)
	if event.is_action_released("sure_continue", true):
		_next(true)

func _next(can_exit: bool)->void:
	if is_choice_mode_enabled:
		_add_log_text("", tr("dialog_choose_an_option"))
		return
	if len(data.dialog) <= entry_idx:
		if can_exit:
			data = null
			dialogo.text = ""
			speech_bubble.text = ""
			is_choice_mode_enabled = false
			active_choices = []
			controller.end_dialog()
		else:
			_add_log_text("", tr("dialog_confirm_exit"))
		return

	dialogo.show()
	var curr_entry: DialogItemData = data.dialog[entry_idx]
	var text: String = tr(curr_entry.text)

	_add_log_text(curr_entry.speaker_name, text)
	_set_speech_bubble_text(text)
	_set_choices(curr_entry.resp)
	entry_idx+=1
func _add_log_text(speaker: String, msg: String)->void:
	if speaker == "":
		dialogo.append_text("[color=#4F4F4F]%s[/color]\n" % msg)
	else:
		dialogo.append_text("{name}: {content}\n".format({
			"name": speaker,
			"content": msg,
		}))
func _set_speech_bubble_text(msg: String)->void:
	speech_bubble.text = msg
	if msg == "":
		speech_bubble_bg.hide()
		return
	speech_bubble_bg.show()
	var tweener: Tween = create_tween()
	tweener.set_parallel()

	var time_to_full_render: float = max(speech_bubble.text.length() / char_speed, 1)
	tweener.tween_property(
		speech_bubble,
		"visible_ratio",
		1.0,
		time_to_full_render
	).from(0.0)
	tweener.tween_property(
		speech_bubble_bg,
		"size",
		Vector2(speech_bubble_bg.size.x, speech_bubble.get_content_height() + 5),
		time_to_full_render
	).from(Vector2(speech_bubble_bg.size.x, speech_bubble.get_theme_font("normal_font").get_height() + 5))
func _set_choices(choices: Array[DialogItemResponse])->void:
	active_choices = choices
	if len(choices) < 1:
		return
	is_choice_mode_enabled = true

	for i in range(choices):
		var rep = choices[i]

		var option: Panel = screen.find_child("option_%s" % i)
		if option == null:
			printerr("could not find dialog option box number %s" % i)
			# Maybe add more dynamically?
			# Another choice is making sure ethe number of options is the maximum number
			# of possible responses
			continue
		if i < 4:
			# Show first page
			option.show()

		var text_label: RichTextLabel = screen.find_child("RichText")
		text_label.text = tr(rep.text)

func _is_valid_dialog_prop(prop_set: String)->bool:
	for p in prop_sets.keys():
		if prop_set == p:
			return true
	return false
