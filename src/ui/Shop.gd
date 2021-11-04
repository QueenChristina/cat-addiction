extends Area2D

var in_icon = false

onready var icon = $Icon
onready var shop_panel = $Panel
onready var sound = $shopSound

var shopOpen = preload("res://assets/audio/openShopBell.wav")
var shopClose = preload("res://assets/audio/closeShopBell.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouse and event.is_action_pressed("click") and in_icon:
		shop_panel.visible = !shop_panel.visible
		if shop_panel.visible:
			sound.stream = shopOpen
		else:
			sound.stream = shopClose
		sound.play(0)

func _on_icon_mouse_entered():
	icon.scale = Vector2(1.4, 1.4)
	in_icon = true

func _on_icon_mouse_exited():
	icon.scale = Vector2(1, 1)
	in_icon = false

func _on_Exit_icon_pressed(_type):
	shop_panel.visible = false