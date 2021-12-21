extends Area2D

export var coin_value := 1
export var cash_value := 5
export var chance_cash := 0.3 # between 0 and 1 chance, TODO: chance increase with upgrades

signal play_sound(type)

var type
var consty
var t = 0
var stopy
var xdirection
var deltax
var a = 0.2
#var OFFSET_X = 4
var OFFSET_Y = 7
var pitch = 1
#var cling = load("res://Audio/Cling.wav")

onready var Icon = $Type
onready var tween = $Tween
onready var shape = $CollisionShape2D

func _ready():
	shape.disabled = true
	switchType("coin")
	if rand_range(0, 1) < chance_cash:
		switchType("cash")
#	set_pos()
	
# Money should pop out from mouse cursor location and move down - depreciated
# UPDATE: come from manually set position
func set_pos(pos):
	deltax = rand_range(0, 5)
	stopy = rand_range(get_viewport().get_visible_rect().size.y - 30, get_viewport().get_visible_rect().size.y - 8)
	a = rand_range(0.08, 1.5)
	var OFFSET_X = int(rand_range(-12, 12))
	OFFSET_Y += int(rand_range(0, 4))
	
#	self.global_position = get_viewport().get_mouse_position()
	self.global_position = pos
	
	if self.global_position.x > get_viewport().get_visible_rect().size.x / 2:
		xdirection = 1
	else:
		xdirection = -1
	self.position += Vector2(xdirection * 5, 5)
#	consty = self.position.y
#	self.position += Vector2(xdirection * OFFSET_X, OFFSET_Y)
#

	tween.interpolate_property(self, "global_position", 
		self.global_position, 
		Vector2(self.global_position.x + OFFSET_X, stopy), rand_range(0.2, 0.6), Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	
#func _process(delta):
#	if self.global_position.y > stopy:
#		pass
#	else:
#		self.position.x += xdirection * 0.1 * deltax
#		self.position.y = a * pow(t, 2) + consty
#		t += 1

func _on_mouse_entered():
	emit_signal("play_sound", "money", pitch)
	if type == "coin":
		Globals.bank += coin_value
	elif type == "cash":
		Globals.bank += cash_value
	self.queue_free()

func switchType(type):
	self.type = type
	Icon.animation = type
	if type == "cash":
#		Sound.set_pitch_scale(rand_range(1.8, 2.2))
		pitch = rand_range(1.8, 2.2)
	elif type == "coin":
#		Sound.set_pitch_scale(rand_range(0.5, 1.5))
		pitch = rand_range(0.5, 1.5)

func _on_tween_completed(object, key):
	shape.disabled = false
