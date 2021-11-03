extends Area2D

var love = preload("res://src/money/Love.tscn")
var money = preload("res://src/money/Money.tscn")

var in_cat = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
#	if Input.is_action_pressed("click"):
	if event is InputEventMouse and event.is_action_pressed("click") and in_cat:
		Globals.score += 1
		# Spawn love and money
		var new_spark = love.instance()
		event = make_input_local(event)
		new_spark.position = event.position
		self.add_child(new_spark)
		if rand_range(0, 1) < Globals.chance_get_money:
			var new_money = money.instance()
			self.add_child(new_money)

func _on_Cat_mouse_entered():
	in_cat = true

func _on_Cat_mouse_exited():
	in_cat = false
