extends Node2D

var bank = 0 # amount of money
var score = 0
export var chance_get_money = 0.1 # TODO: increase with upgrades, change money spawns when click cat
var inventory = {"pill" : 1, "weed" : 1, "cig" : 1} # Format of item_id : amount
var equipped = {"hat" : "", "mouth" : "", "body" : ""} # Equipped items of format type : item_id
var items = {}

func _ready():
	items = loadFile("res://data/items.json")

func add_to_inventory(item_id):
	if !Globals.inventory.has(item_id):
		Globals.inventory[item_id] = 1
	else:
		Globals.inventory[item_id] += 1

# Loads a file as JSON, returns JSON
func loadFile(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, file.READ)
		var file_content = parse_json(file.get_as_text())
		if file_content == null:
			print("Could not parse " + file_name + " as JSON." + \
			"Please check syntax is correct, and that file is not empty.")
		return file_content
	else:
		print("File Open Error: could not open file " + file_name)
	file.close()
