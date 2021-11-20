extends Node2D

signal randomize_shop
signal achievement_reached(id)

var bank = 100 # amount of money
var score = 0 setget set_score
export var chance_get_money = 0.1 # TODO: increase with upgrades, change money spawns when click cat
var inventory = {"clicker" : 0,"pill" : 1, "weed" : 1, "cig" : 1} # Format of item_id : amount
var equipped = {"hat" : "", "mouth" : "", "body" : ""} # Equipped items of format type : item_id
var items = {}
var buyable_items = {"clicker" : 1000, "pill" : 1, "weed" : 1, "cig" : 1,
					"bunny" : 1, "birb" : 1, "redHerring" : 1,
					"propeller" : 1, "hairyPawter" : 1,
					"poop" : 1} # List of buyable items by
# item_id : amount -- to be added to manually as you make more items and story
# progresses and/or player gets richer
var achievements = {}
var score_to_achievement = {}
var SHOP_REFRESH_RATE = 50 # amount of score to go through before refreshing shop, upgradable?

func _ready():
	items = loadFile("res://data/items.json")
	achievements = loadFile("res://data/achievements.json")
	generate_score_to_achievement()

# Generates a dictionary of score needed to reach a certain
# achievement id
# <!> Assumes that no two achievements can occur at the same score
# count
func generate_score_to_achievement():
	for id in achievements.keys():
		if achievements[id].has("occur_at_count"):
			var score_needed = achievements[id]["occur_at_count"]
			score_to_achievement[str(score_needed)] = id

func set_score(val):
	score = val
	# Refresh shop every few counts
	if (score % SHOP_REFRESH_RATE == 0):
		emit_signal("randomize_shop")
	# Check if received achivements for milestones
	if score_to_achievement.has(str(val)):
		emit_signal("achievement_reached", score_to_achievement[str(val)])
	
func add_to_inventory(item_id):
	if(item_id=="clicker"):
		
		get_node("../World/AutoClickers").add_clicker()
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
