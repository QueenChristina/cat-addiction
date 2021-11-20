extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var cat=get_node("../Cat")
var auto_clicker_scene = preload("res://src/scenes/AutoClicker.tscn")
var clickers=[]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func add_clicker():
	var c=auto_clicker_scene.instance()
	c.set_cat(cat)
	add_child(c)
	clickers.append(c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
