class_name DataLoader

static func load_dialog(id: String)-> DialogData:
	var dat: DialogData = DialogData.new()
	dat.dialog_name = id

	var json_res: FileAccess = FileAccess.open("res://data/dialogs/%s.json" % id, FileAccess.READ)
	var txt: String = json_res.get_as_text()
	json_res.close()

	var json = JSON.new()
	var error = json.parse(txt)
	if error != OK:
		printerr("failed to load dialog resource \"%s\"" % id )
		printerr("JSON Parse Error: ", json.get_error_message(), " in resource at line ", json.get_error_line())
		return dat

	var dict_dat: Dictionary = json.data
	dat.prop_set = dict_dat.get("propset")
	
	for entry in dict_dat.get("dialog"):
		var dat_entry = DialogItemData.new()
		dat_entry.speaker = entry.get("speaker")
		dat_entry.speaker_name = entry.get("name")
		dat_entry.text = entry.get("text")

		for cond in entry.get("cond"):
			dat_entry.cond.append(cond)
		for resp in entry.get("resp"):
			var dat_resp = DialogItemResponse.new()
			dat_resp.text = dat_resp.get("text")
			dat_resp.eff = dat_resp.get("eff")
			dat_entry.resp.append(dat_resp)

		dat.dialog.append(dat_entry)

	return dat
