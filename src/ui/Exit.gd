extends Area2D
class_name ClickableIcon
"""
NOTE: in the future, use a button for this instead. -_-
"""

signal icon_pressed(type)

export var icon_type = "exit"
export(String, FILE) var sound_file

var in_icon = false

onready var sound = $ClickSound

# Called when the node enters the scene tree for the first time.
func _ready():
	sound.stream = load(sound_file)

func _input(event):
	if event is InputEventMouse and event.is_action_pressed("click") and in_icon:
		emit_signal("icon_pressed", icon_type)
		sound.play(0)

func _on_icon_mouse_entered():
	self.scale = Vector2(1.4, 1.4)
	in_icon = true

func _on_icon_mouse_exited():
	self.scale = Vector2(1, 1)
	in_icon = false
