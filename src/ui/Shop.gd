extends Area2D

signal opened()

var in_icon = false
export var max_items_in_shop = 8 # TODO: upgradeable amount

onready var icon = $Icon
onready var shop_panel = $Panel
onready var sound = $shopSound

var shopOpen = preload("res://assets/audio/openShopBell.wav")
var shopClose = preload("res://assets/audio/closeShopBell.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	manage_shop()

func _input(event):
	if event is InputEventMouse and event.is_action_pressed("click") and in_icon:
		shop_panel.visible = !shop_panel.visible
		if shop_panel.visible:
			sound.stream = shopOpen
			shop_panel.open()
			emit_signal("opened")
		else:
			sound.stream = shopClose
		sound.play(0)

func close():
	shop_panel.visible = false

func _on_icon_mouse_entered():
	icon.scale = Vector2(1.4, 1.4)
	in_icon = true

func _on_icon_mouse_exited():
	icon.scale = Vector2(1, 1)
	in_icon = false

func manage_shop():
	shop_panel.open() # Reformats text and animation to open shop type - NOT visibility
	shop_panel.clear()
	shop_panel.populate(spawn_items(max_items_in_shop))
	
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
