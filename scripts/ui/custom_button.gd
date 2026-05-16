@tool
extends BaseButton
## Class to have the same style in all the game's buttons
class_name CustomButton

@onready var _bg: ColorRect = $bg
@onready var _label: RichTextLabel = $label

var _bg_color: Color = Color(0, 0, 0)
var _is_visible: bool = false
var _mouse_on: bool = false

@export var text: String = "":
	set(new_text):
		if _label != null:
			_label.text = tr(new_text)
		text = new_text
@export var input_bind: StringName = ""
var action: Callable = __default_action:
	set(new_fn):
		if new_fn == null:
			action = __default_action
		else:
			action = new_fn

func __default_action():
	print("%s acted!" % self.get_path())

func _ready() -> void:
	_label.text = tr(text)
func _gui_input(event: InputEvent) -> void:
	if disabled or not _is_visible:
		return
	if !event.is_action_released(&"click", true):
		return
	action.call()
func _input(event: InputEvent) -> void:
	if disabled or input_bind == &"" or not _is_visible:
		return
	if event.is_action_released(input_bind, true):
		action.call()

func _on_mouse_entered() -> void:
	_mouse_on = true
	var darker_color = _bg.self_modulate.darkened(0.25)
	_bg_color = _bg.color
	_bg.color = darker_color
func _on_mouse_exited() -> void:
	_mouse_on = false
	_bg.color = _bg_color
func _on_visibility_changed() -> void:
	_is_visible = is_visible_in_tree()
