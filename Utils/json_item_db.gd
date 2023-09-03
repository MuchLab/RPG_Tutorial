extends Node

var script_url = "res://Database/json_db/item_db.json"
var work_path = "res://Art/Items/"

func load_data(url):
	var file = FileAccess.open(url, FileAccess.READ)
	if not file.file_exists(url):
		return null
	var data = {}
	data = JSON.parse_string(file.get_as_text())
	file.close()
	return data
	
func get_item_by_id(item_name):
	var item_data = {}
	item_data = load_data(script_url)
	if item_data == null:
		print("Item " + item_name + "does not exists.")
		return null
	item_data[item_name]["name"] = item_name
	return item_data[item_name]
	
func smart_texture_load(item_id):
	if item_id["texture"] is Texture:
		return item_id["texture"]
	else:
		item_id["texture"] = load(work_path + item_id["texture"])
		return item_id["texture"]
	
