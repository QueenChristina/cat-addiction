extends Button

# TODO: item description based on hover and global position.
# (usable both in shop and inventory)
# HOWEVER - note that hover doesn't work well on mobile -- alternatives?

signal item_selected(item_id)

export var id = "weed" # dictates item icon to display, name of icon
export var display_name = "Weed" # dictates name to display
export var price = 420 # Nice.
export var description = "Wearable weed of wonder. Say no more." # to display in shop
export var type = "hat"

var state = "unselected" setget set_state
var show_inventory_amount = false # True if show inventory amount, false if show buyable items amount

onready var select_animation = $Selected/AnimationPlayer
onready var select_sound = $AudioStreamPlayer
onready var items = $Display
onready var item_icon = $Display/Item # Must be an animatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state("unselected")
#	init("weed") # testing
	
# Call to initialize display to match item
func init(item_id, is_shown_in_inventory):
	# Set item description and info based on item_id
	id = item_id
	show_inventory_amount = is_shown_in_inventory
	var item_info = Globals.items[id]
	
	if show_inventory_amount:
		set_label_amount(Globals.inventory.get(id, 0))
	else:
		set_label_amount(Globals.buyable_items.get(id,0))
	
	display_name = item_info["name"]
	price = item_info["price"]
	description = item_info["description"]
	type = item_info.get("type","")
	if item_info.has("special_icon"):
		# for items with special icons just for display TODO: delete this, instead use Displays
		item_icon = items.get_node("Item")
		if id=="clicker":
			item_icon.texture=load("res://assets/shop_items/clicker.png")
	elif items.get_node("Displays").frames.has_animation(id):
		# Use displays for this item different from what is used for cat
		item_icon = items.get_node("Displays")
		item_icon.animation = id
	else:
		if type == "hat":
			item_icon = items.get_node("HatDecor")
		elif type == "mouth":
			item_icon = items.get_node("MouthDecor")
		elif type == "body":
			item_icon = items.get_node("BodyDecor")
		else:
			print("WARNING: unknown item type.")
			item_icon = items.get_node("Item")
		item_icon.animation = id # assumes: animation name MUST match item id

	for item in items.get_children():
		item.hide()
	item_icon.show()

func _on_ItemContainer_pressed():
	set_state("selected")
	select_sound.play(0)

func set_state(new_state):
	assert(new_state == "unselected" or new_state == "selected" or new_state == "oos")
	state = new_state
	if state == "selected":
		select_animation.play("selected")
		emit_signal("item_selected", id)
	elif state == "unselected":
		select_animation.play("not_selected")
	else:
		#item_icon.hide()
		#id = ""
		#display_name = ""
		price = -1
		description = "Sold out." # to display in shop
	# depends on if inventory or shop -- use global amount if shop, otherwise use inventory amount
	if show_inventory_amount:
		set_label_amount(Globals.inventory.get(id, 0))
	else:
		set_label_amount(Globals.buyable_items.get(id,0))
	
func set_label_amount(amount):
	if amount == INF:
		# Display something if amount is INF TODO: add an infinity sign into the font
		$Available.text = ""
	else:
		$Available.text = str(amount)
