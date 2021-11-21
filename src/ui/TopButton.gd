extends TextureButton
class_name ClickableTopButton
"""
NOTE: in the future, use a button for this instead if simple texture. -_-
Usable for clickable icon, can hide or show children based on click.
Will make hover animation with simple scale.
More flexible than button -- allows extension to make icon animated.
"""

signal icon_pressed(type)
signal opened()

export var icon_type = "exit"
export(String, FILE) var sound_file
export(NodePath) var make_visible_on_click = null

var in_icon = false

onready var sound = $ClickSound
onready var hover_sound = $HoverSound
onready var icon = self
var was_hovered=false
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_over",self,"_on_icon_mouse_entered")
	connect("focus_exit",self,"_on_icon_mouse_exited")
	connect("pressed",self,"_got_clicked")
	sound.stream = load(sound_file)

func _input(event):
	if is_hovered() and not was_hovered:
		was_hovered=true
		_on_icon_mouse_entered()
	if not is_hovered() and was_hovered:
		was_hovered=false
		_on_icon_mouse_exited()
#	if event is InputEventMouse and event.is_action_pressed("click") and in_icon:
#		sound.play(0)
#		if make_visible_on_click != null:
#			var node = get_node(make_visible_on_click)
#			node.visible = !node.visible
#			if node.visible:
#				emit_signal("opened")
#		emit_signal("icon_pressed", icon_type)

func close():
	if make_visible_on_click != null:
		var node = get_node(make_visible_on_click)
		node.visible = false
func _got_clicked():
	if make_visible_on_click != null:
		var node = get_node(make_visible_on_click)
		node.visible = !node.visible
		if node.visible:
			emit_signal("opened")
func _on_icon_mouse_entered():
	self.rect_pivot_offset=self.rect_size/2
	self.rect_scale = Vector2(1.4, 1.4)
	hover_sound.play(0)

func _on_icon_mouse_exited():
	self.rect_scale = Vector2(1, 1)
