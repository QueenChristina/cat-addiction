tool
extends Node2D

export(Color, RGBA) var col setget set_col

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_col(val):
	col = val
	for grad in self.get_children():
		grad.texture = GradientTexture.new()
		grad.texture.gradient = Gradient.new()
		grad.texture.gradient.colors[0] = col
		grad.texture.gradient.colors[1] = Color(1, 1, 1, 0)
