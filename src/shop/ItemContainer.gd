extends Button

signal item_selected(item_id)

export var id = "weed" # dictates item icon to display, name of icon
export var display_name = "Weed" # dictates name to display
export var price = 420 # Nice.
export var description = "Wearable weed of wonder. Say no more." # to display in shop
# TODO: pull item info from json

var state = "unselected" setget set_state

onready var select_animation = $Selected/AnimationPlayer
onready var select_sound = $AudioStreamPlayer
onready var item_icon = $Item

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state("unselected")
	
func init(item_id):
	# Set item description and info based on item_id
	id = item_id
	# TODO

func _on_ItemContainer_pressed():
	set_state("selected")
	select_sound.play(0)

func set_state(new_state):
	assert(new_state == "unselected" or new_state == "selected" or new_state == "bought")
	state = new_state
	if state == "selected":
		select_animation.play("selected")
		emit_signal("item_selected", id)
	elif state == "unselected":
		select_animation.play("not_selected")
	else:
		item_icon.hide()
		id = ""
		display_name = ""
		price = -1
		description = "Sold out." # to display in shop
