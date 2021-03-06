extends NinePatchRect

signal equip(item_id, item_type)
signal unequip(item_type)

var selected_item
var in_clickable_area = false

onready var items_grid = $ScrollContainer/GridContainer
onready var item_display = preload("res://src/shop/ItemContainer.tscn")
onready var button_use = $UseButton
onready var description = $Description
onready var warning = $UseButton/Warning

# Called when the node enters the scene tree for the first time.
func _ready():
	update_bag()
	button_use.connect("pressed",self,"_on_UseButton_pressed")
		
# Update bag contents to match inventory
func update_bag():
	# Clear bag of old items
	for item in items_grid.get_children():
		item.queue_free()
	# Populate bag with current items
	for id in Globals.inventory.keys():
		if Globals.inventory[id] > 0: # account for amount, eg. if amount == 0, don't populate
			var item = item_display.instance();
			items_grid.add_child(item)
			item.init(id, true)
			item.connect("item_selected", self, "_on_item_selected", [item])
			
			if item.type != "perma":
				items_grid.move_child(item, 0) # Sort permanent items to the end
	button_use.disabled = true
	description.bbcode_text = ""
		
func _on_item_selected(item_id, item):
	# Unselect all items except selected
	selected_item = item
	for other_item in items_grid.get_children():
		if other_item != item:
			other_item.state = "unselected"
			
	# Set button text based on item selected type
	if item.type != "perma":
		button_use.disabled = false
	else:
		button_use.text = "In use"
		button_use.disabled = true
		
	if item.type == "consumable":
		button_use.text = "Use"
	elif item.type == "hat" or item.type == "mouth" or item.type == "body":
		if Globals.equipped[item.type] == item_id:
			button_use.text = "Unequip"
		else:
			button_use.text = "Equip"
	# Item description
	description.hide()
	var desc = Globals.items[item_id]["description"]
	if Globals.items[item_id].has("dpm_per_sec"):
		desc += "[color=green]\n+" + str(Globals.items[item_id]["dpm_per_sec"]) + " dpm/sec[/color]*"
	description.bbcode_text = "[center]" +  desc + "[/center]"
	description.show()

func _on_Bag_icon_pressed(type):
	if self.visible:
		update_bag()

func _on_UseButton_pressed():
	if selected_item.type == "consumable":
		Globals.inventory[selected_item.id] -= 1
		update_bag()
	# If hat, body, or mouth, send signal to cat to equip appropirate attire
	elif selected_item.type == "hat" or selected_item.type == "mouth" or selected_item.type == "body":
		if button_use.text == "Equip":
			button_use.text = "Unequip"
			# Swap with currently equipped item and add back to inventory
			var old_equipped_id = Globals.equipped[selected_item.type]
			emit_signal("equip", selected_item.id, selected_item.type)
			# Show warning if applicable
			if Globals.items[selected_item.id].has("dpm_per_sec"):
				warning.show()
		elif button_use.text == "Unequip":
			button_use.text = "Equip"
			warning.hide()
			emit_signal("unequip", selected_item.type)

## Hacky workaround with UIs to hide when click off of bag
#func _on_HideButton_pressed():
#	self.hide()

func _on_UseButton_mouse_entered():
	if button_use.text == "Unequip" and Globals.items[selected_item.id].has("dpm_per_sec"):
		warning.show()

func _on_UseButton_mouse_exited():
	warning.hide()
