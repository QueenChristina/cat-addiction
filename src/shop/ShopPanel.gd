extends NinePatchRect

# TODO: add upgrade items, special consumables, etc.

onready var items_grid = $GridContainer
onready var name_tag = $NameTag
onready var description = $Description
onready var buy_button = $Buy
export var max_items_in_shop = 100 # TODO: upgradeable amount

onready var item_display = preload("res://src/shop/ItemContainer.tscn")

var selected_item
var was_open=false

onready var sound = $shopSound

var shopOpen = preload("res://assets/audio/openShopBell.wav")
var shopClose = preload("res://assets/audio/closeShopBell.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in items_grid.get_children():
		item.connect("item_selected", self, "_on_item_selected", [item])
	manage_shop()
	Globals.connect("randomize_shop", self, "manage_shop")
# TODO: parent should have the logic to control and populate shop panel
# 	items: Takes in a dictionairy of items by item_id : amount
# TODO: make amount matter - right now, amount is assumed to be 1
func populate(item_ids):
	for id in item_ids.keys():
		var item = item_display.instance();
		items_grid.add_child(item)
		item.init(id)
		item.connect("item_selected", self, "_on_item_selected", [item])
	
# Usually called before populate_shop to clear the shop of previos item displays
func clear():
	for item in items_grid.get_children():
		item.queue_free()
		
# Called when open shop, to clear out previous selections and look pretty
func open():
	# Unselect all items
	for item in items_grid.get_children():
		item.state = "unselected"
	# Update display text
	name_tag.bbcode_text = "Welcome!"
	description.bbcode_text = "Select an item to view and buy."
	buy_button.disabled = true
func _process(delta):
	if visible and not was_open:
		was_open=true
		sound.stream = shopOpen
		sound.play(0)
	if not visible and was_open:
		was_open=false
		sound.stream = shopClose
		sound.play(0)
		
	
func _on_item_selected(item_id, item):
	# Unselect all items except selected
	selected_item = item
	for other_item in items_grid.get_children():
		if other_item != item:
			other_item.state = "unselected"
	# Update item nametag, price, description
	var price = "$" + str(item.price) if item.price >= 0 else ""
	name_tag.bbcode_text = item.display_name + "   " + price
	description.bbcode_text = item.description
	# Disable button if can't afford item -- otherwise, enable and listen for presses
	if item.price <= Globals.bank and item.price >= 0:
		# Can afford
		buy_button.disabled = false
	else:
		buy_button.disabled = true

func _on_BuyButton_pressed():
	buy_button.get_node("AudioStreamPlayer").play(0)
	# remove from shop, and subtract price from bank
	Globals.bank -= selected_item.price
	# Add item to inventory
	Globals.add_to_inventory(selected_item.id)
	# Remove from future buyable items (TODO: calibrate amount)
	Globals.buyable_items[selected_item.id] -= 1
	if Globals.buyable_items[selected_item.id] <= 0:
		Globals.buyable_items.erase(selected_item.id)
	# Change shop text
		selected_item.state = "oos"
		name_tag.bbcode_text = ""
		description.bbcode_text = "Thank you for your mooolah!!!"
		buy_button.disabled = true


func _on_Exit_icon_pressed(type):
	self.visible = false


func manage_shop():
	self.open() # Reformats text and animation to open shop type - NOT visibility
	self.clear()
	self.populate(spawn_items(max_items_in_shop))
	
# Returns a dictionary of random items of item_id : amount to spawn in shop
# Use with manage_shop
# up to num_items to spawn (constrained by number of available items): usually in multiples of x4
var rng = RandomNumberGenerator.new()
func spawn_items(num_items):
	var items = {}
	var num_to_spawn = num_items if Globals.buyable_items.size() > num_items else Globals.buyable_items.size()
	var buyable_items = Globals.buyable_items.duplicate()
	for i in range(num_to_spawn):
		rng.randomize()
		var rand_ind = rng.randi_range(0, buyable_items.size() - 1)
		var item_id = buyable_items.keys()[rand_ind]
		items[item_id] = buyable_items[item_id]
		buyable_items.erase(item_id)
	return items
