@tool
extends BaseButton
## Class to have the same style in all the game's buttons
class_name CustomButton

@onready var _bg: PanelContainer = $bg
@onready var _label: RichTextLabel = $label
@onready var _stylebox_disabled: StyleBox = get_theme_stylebox("disabled", "Button")
@onready var _stylebox_focus: StyleBox = get_theme_stylebox("focus", "Button")
@onready var _stylebox_hover: StyleBox = get_theme_stylebox("hover", "Button")
@onready var _stylebox_normal: StyleBox = get_theme_stylebox("normal", "Button")
@onready var _stylebox_pressed: StyleBox = get_theme_stylebox("pressed", "Button")
@onready var _color_font: Color = get_theme_color("font_color", "Button")
@onready var _color_font_disabled: Color = get_theme_color("font_disabled_color", "Button")
@onready var _color_font_ongoing: Color = _color_font
@onready var _stylebox_ongoing_normal: StyleBox = _stylebox_normal

var _is_visible: bool = false

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
	if self.disabled:
		_stylebox_ongoing_normal = _stylebox_disabled
		_color_font_ongoing = _color_font_disabled
	_bg.add_theme_stylebox_override("panel", _stylebox_ongoing_normal)
	_label.add_theme_color_override("default_color", _color_font_ongoing)
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
	if not self.disabled:
		_bg.add_theme_stylebox_override("panel", _stylebox_hover)
func _on_mouse_exited() -> void:
	_bg.add_theme_stylebox_override("panel", _stylebox_ongoing_normal)
func _on_visibility_changed() -> void:
	_is_visible = is_visible_in_tree()
