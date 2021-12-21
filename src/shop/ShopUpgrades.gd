extends Node

# Controls when to update shop with new items -- see Globals for shop buyable items
# Closely tied with story


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.buyable_items = {
			"pill" : 1, "weed" : 1, 
			"shots" : 1, "weedCape" : 1, 
			"clicker": 5, "clicker_upgrade_hz" : 5} 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#buyable_items = {"pill" : 1, "weed" : 1} 
#inventory
