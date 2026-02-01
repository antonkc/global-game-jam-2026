class_name DataLoader

static func load_dialog(id: String)-> DialogData:
	var dat: DialogData = DialogData.new()
	dat.dialog_name = id

	var txt = load("res://data/dialogs/%s.json" % id)
	var json = JSON.new()
	var error = json.parse(txt)
	if error != OK:
		printerr("failed to load dialog resource \"%s\"" % id )
		printerr("JSON Parse Error: ", json.get_error_message(), " in resource at line ", json.get_error_line())
		return dat

	dat.prop_set = json.data["prop_set"]
	
	for entry in json.data["dialog"]:
		var dat_entry = DialogItemData.new()
		dat_entry.cond = entry["cond"]
		dat_entry.speaker = entry["speaker"]
		dat_entry.speaker_name = entry["name"]

		for resp in entry["resp"]:
			var dat_resp = DialogItemResponse.new()
			dat_resp.text = dat_resp["text"]
			dat_resp.eff = dat_resp["eff"]
			dat_entry.resp.append(dat_resp)

		dat.dialog.append(dat_entry)

	return dat
