extends Area2D
class_name ClickableIcon
"""
NOTE: in the future, use a button for this instead if simple texture. -_-
Usable for clickable icon, can hide or show children based on click.
Will make hover animation with simple scale.
More flexible than button -- allows extension to make icon animated.
"""

#signal icon_pressed(type)
#signal opened()

export var icon_type = "exit"
export(String, FILE) var sound_file
export(NodePath) var make_visible_on_click = null

var in_icon = false

onready var sound = $ClickSound
onready var hover_sound = $HoverSound
onready var icon = $Icon

# Called when the node enters the scene tree for the first time.
func _ready():
	sound.stream = load(sound_file)

func _input(event):
	if event is InputEventMouse and event.is_action_pressed("click") and in_icon:
		sound.play(0)
		
		if make_visible_on_click != null:
			var node = get_node(make_visible_on_click)
			node.visible = !node.visible
#			if node.visible:
#				emit_signal("opened")
		#emit_signal("icon_pressed", icon_type)

func close():
	if make_visible_on_click != null:
		var node = get_node(make_visible_on_click)
		node.visible = false

func _on_icon_mouse_entered():
	icon.scale = Vector2(1.4, 1.4)
	in_icon = true
	hover_sound.play(0)

func _on_icon_mouse_exited():
	icon.scale = Vector2(1, 1)
	in_icon = false
