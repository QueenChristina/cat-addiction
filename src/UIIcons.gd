extends HBoxContainer

"""
NOTE: In the future, use radio buttons instead -_-, or tab container
Closes all open icons outside of selected.
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	for icon in self.get_children():
		icon.connect("opened", self, "_on_icon_selected", [icon])

# Closes all except currently selected
func _on_icon_selected(selected_icon):
	for icon in self.get_children():
		if icon != selected_icon: 
			icon.close()
