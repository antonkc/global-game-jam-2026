@tool
extends RichTextEffect
class_name DreamyText

var bbcode = "dreamy"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed = char_fx.env.get("speed", 1)
	var magnitude = char_fx.env.get("magnitude", 4)
	char_fx.offset.y += magnitude * sin((char_fx.elapsed_time * speed)+(char_fx.relative_index*0.25))
	return true
