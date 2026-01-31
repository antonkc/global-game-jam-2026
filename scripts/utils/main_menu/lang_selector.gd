extends Node

@onready var option_button: OptionButton = $OptionButton

var language = "automatic"
var known_languages = ["en", "es_ES"]

func _ready() -> void:
	var preferred_language = ""
	if language == "automatic":
		preferred_language = OS.get_locale_language()
		var best_language = "en"
		var best_match_score = 0
		for lang in known_languages:
			var score = _score_lang_match(preferred_language, lang) 
			if score > best_match_score:
				best_language = lang
				best_match_score = score
		preferred_language = best_language
		TranslationServer.set_locale(preferred_language)

	var idx = 0
	var i = 0
	for lang in known_languages:
		option_button.add_item(lang)
		if lang == preferred_language:
			idx = i
		i+=1
	option_button.select(idx)

func _on_option_button_item_selected(idx: int) -> void:
	var lang: String = option_button.get_item_text(idx)
	language = lang
	TranslationServer.set_locale(lang)

func _score_lang_match(a: String, b: String)-> int:
	var aSplit = a.split('_')
	var bSplit = b.split('_')

	if aSplit[0] != bSplit[0]:
		return 0

	if len(aSplit) != len(bSplit):
		return 1
	if len(aSplit) < 2:
		return 2

	if aSplit[1] != bSplit[1]:
		return 1

	return 2
