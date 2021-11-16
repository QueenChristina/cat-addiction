extends PanelContainer

onready var label_name = $VBoxContainer/Name
onready var label_descrip = $VBoxContainer/Description

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(a_name, description, style):
	label_name.bbcode_text = a_name
	label_descrip.bbcode_text = description
	# TODO: something with style
