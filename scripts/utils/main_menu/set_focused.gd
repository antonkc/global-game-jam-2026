extends Node
class_name FocusHelper

static func set_focused(node: Node, focused: bool)->void:
	var buttons: Array[Node] = node.find_children("butt_*", "Panel", true)
	
	for butt in buttons:
		if "is_input_focused" in butt:
			butt.is_input_focused = focused
			butt.set_process_input(focused)
			butt.set_process(focused)
