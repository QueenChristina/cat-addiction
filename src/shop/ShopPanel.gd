extends NinePatchRect

onready var items_grid = $GridContainer
onready var name_tag = $NameTag
onready var description = $Description
onready var buy_button = $Buy

var selected_item

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in items_grid.get_children():
		item.connect("item_selected", self, "_on_item_selected", [item])
		
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
	# Add item to inventory, remove from shop, and subtract price from bank
	Globals.bank -= selected_item.price
	if !Globals.inventory.has(selected_item.id):
		Globals.inventory[selected_item.id] = 1
	else:
		Globals.inventory[selected_item.id] += 1
	selected_item.state = "bought"
	name_tag.bbcode_text = ""
	description.bbcode_text = "Thank you for your moooney!!!"
	buy_button.disabled = true
