extends Control
class_name Dialog


# TODO: Make this not broken :D

const _CHOICES_PER_PAGE: int = 4

@export var char_speed: float = 25.0

var _entry_idx: int = 0
var _data: DialogData = null
var _is_choice_mode_enabled: bool = false
var _active_choices: Array[DialogItemResponse] = []
var _effects: Array[String] = []
var _choice_page: int = 0

@onready var _root: Dialog = $"."
@onready var _controller: Location = $".".find_parent("location")
@onready var _dialog: RichTextLabel = $dialog_log/RichTextLabel
@onready var _options: Control = $options
@onready var _speech_bubble_bg: ColorRect = $speech_bubble/ColorRect
@onready var _speech_bubble: RichTextLabel = $speech_bubble/RichTextLabel

func load_dialog(in_data: DialogData, in_effects: Array[String])-> void:
	if in_data == null:
		printerr("tried to load null dialog")
		return
	print_debug("starting load for dialog \"%s\"" % in_data.dialog_name)
	_data = in_data
	_entry_idx = 0
	_effects = in_effects.duplicate()
	if in_data.prop_set != "":
		if !_is_valid_dialog_prop(in_data.prop_set):
			printerr("an invalid prop_set was declared \"%s\"" % in_data.prop_set)
		else:
			#TODO: load prop_set
			pass
	_next(false)
func select_choice(i: int)->void:
	i = (_CHOICES_PER_PAGE * _choice_page) + i
	if _active_choices.size() <= i || i < 0:
		printerr("tried to select invalid choice %s" % i)
		return

	var choice = _active_choices[i]
	_add_log_text("Ali", tr(choice.text))
	_effects.append_array(choice.eff)
	if _controller != null:
		for eff in choice.eff:
			_controller.add_effect(eff)
	_is_choice_mode_enabled = false

	for option in _options.find_children("option_*", "CustomButton", false):
		if option is CustomButton:
			option.hide()

	_next(false)

func _ready() -> void:
	var choice_i: int = 0
	for option in _options.find_children("option_*", "CustomButton", false):
		if option is CustomButton:
			option.action = Callable(self, &"select_choice").bind(choice_i)
			choice_i+=1

func _input(event: InputEvent) -> void:
	if !_root.visible:
		return
	if event.is_action_released("sure_continue", true):
		_next(true)
	elif event.is_action_released("continue", true):
		_next(false)
	elif event.is_action_released("option_5", true):
		pass # TODO: Paging
	elif event.is_action_released("option_6", true):
		pass # TODO: Paging
func _next(can_exit: bool)->void:
	if _is_choice_mode_enabled:
		_add_log_text("", tr("dialog_choose_an_option"))
		return
	if _data.dialog.size() <= _entry_idx:
		_exit_dialog(can_exit)
		return

	_dialog.show()
	var curr_entry: DialogItemData = null
	for _idx in range(_entry_idx, _data.dialog.size()):
		_entry_idx = _idx
		curr_entry = _data.dialog[_entry_idx]
		var condition_met = true
		
		for cond in curr_entry.cond:
			if not (cond in _effects):
				condition_met = false

		if condition_met:
			break
		else:
			curr_entry = null
	if curr_entry == null:
		_exit_dialog(can_exit)
		return
	var text: String = tr(curr_entry.text)

	_add_log_text(curr_entry.speaker_name, text)
	_set_speech_bubble_text(text)
	_set_choices_texts(curr_entry.resp)
	_entry_idx+=1
func _add_log_text(speaker: String, msg: String)->void:
	if speaker == "":
		_dialog.append_text("[color=#4F4F4F]%s[/color]\n" % msg)
	else:
		_dialog.append_text("{name}: {content}\n".format({
			"name": speaker,
			"content": msg,
		}))
func _set_speech_bubble_text(msg: String)->void:
	_speech_bubble.text = msg
	if msg == "":
		_speech_bubble_bg.hide()
		return
	_speech_bubble_bg.show()
	var tweener: Tween = create_tween()
	tweener.set_parallel()

	var time_to_full_render: float = max(_speech_bubble.text.length() / char_speed, 1)
	tweener.tween_property(
		_speech_bubble,
		"visible_ratio",
		1.0,
		time_to_full_render
	).from(0.0)
	tweener.tween_property(
		_speech_bubble_bg,
		"size",
		Vector2(_speech_bubble_bg.size.x, _speech_bubble.get_content_height() + 5),
		time_to_full_render
	).from(Vector2(_speech_bubble_bg.size.x, _speech_bubble.get_theme_font("normal_font").get_height() + 5))
func _set_choices_texts(choices: Array[DialogItemResponse])->void:
	_active_choices = choices
	if choices.size() < 1:
		return
	_is_choice_mode_enabled = true

	for i in range(_CHOICES_PER_PAGE):
		var idx = (_CHOICES_PER_PAGE * _choice_page) + i
		if choices.size() <= idx:
			break
		var rep = choices[idx]

		var option: CustomButton = _options.find_child("option_%s" % i, false)
		if option == null:
			printerr("could not find dialog option box number %s" % i)
			# scene was changed badly
			continue
		option.show()
		option.text = rep.text

func _exit_dialog(can_exit: bool):
	if can_exit:
		_data = null
		_dialog.text = ""
		_speech_bubble.text = ""
		_is_choice_mode_enabled = false
		_active_choices = []
		if _controller != null:
			_controller.end_dialog()
		else:
			printerr("tried to end dialog in a dialog only scene")
	else:
		_add_log_text("", tr("dialog_confirm_exit"))

func _is_valid_dialog_prop(prop_set: String)->bool:
	for p in prop_sets.keys():
		if prop_set == p:
			return true
	return false
