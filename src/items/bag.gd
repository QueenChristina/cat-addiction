extends NinePatchRect

signal equip(item_id, item_type)
signal unequip(item_type)

var selected_item

onready var items_grid = $ScrollContainer/GridContainer
onready var item_display = preload("res://src/shop/ItemContainer.tscn")
onready var button_use = $UseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	update_bag()

# Update bag contents to match inventory
func update_bag():
	# Clear bag of old items
	for item in items_grid.get_children():
		item.queue_free()
	# Populate bag with current items
	for id in Globals.inventory.keys():
		if Globals.inventory[id] > 0:
			var item = item_display.instance();
			# TODO: account for amount, eg. if amount == 0, don't populate
			items_grid.add_child(item)
			item.init(id)
			item.connect("item_selected", self, "_on_item_selected", [item])
	button_use.disabled = true
		
func _on_item_selected(item_id, item):
	# Unselect all items except selected
	selected_item = item
	for other_item in items_grid.get_children():
		if other_item != item:
			other_item.state = "unselected"
			
	# Set button text based on item selected type
	button_use.disabled = false
	if item.type == "consumable":
		button_use.text = "Use"
	elif item.type == "hat" or "mouth" or "body":
		if Globals.equipped[item.type] == item_id:
			button_use.text = "Unequip"
		else:
			button_use.text = "Equip"

func _on_Bag_icon_pressed(type):
	if self.visible:
		update_bag()

func _on_UseButton_pressed():
	if selected_item.type == "consumable":
		Globals.inventory[selected_item.id] -= 1
		update_bag()
	# If hat, body, or mouth, send signal to cat to equip appropirate attire
	else:
		if button_use.text == "Equip":
			button_use.text = "Unequip"
			emit_signal("equip", selected_item.id, selected_item.type)
			# Swap with currently equipped item and add back to inventory
			var old_equipped_id = Globals.equipped[selected_item.type]
			Globals.equipped[selected_item.type] = selected_item.id
		elif button_use.text == "Unequip":
			button_use.text = "Equip"
			emit_signal("unequip", selected_item.type)
			Globals.equipped[selected_item.type] = ""
