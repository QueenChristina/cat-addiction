extends PanelContainer

onready var label_name = $MarginContainer/Name
onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(a_name, description, style):
#	label_descrip.bbcode_text = description
	label_name.bbcode_text = a_name
	# TODO: something with style / icon
	anim.stop(true)
	anim.play("notif")
