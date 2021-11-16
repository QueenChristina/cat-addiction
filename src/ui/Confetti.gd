extends Node2D

onready var normal = $Normal
onready var cats = $Cats

var playing_confetti
var CONFETTI_SHOW_TIME = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play(style):
	if style == "":
		return
	elif style == "normal":
		normal.emitting = true
		playing_confetti = normal
	elif style == "cats":
		cats.emitting = true
		playing_confetti = cats
	elif style == "cats_wacky":
		$CatsWacky.emitting = true
		playing_confetti = $CatsWacky
	else:
		print("WARNING: could not play confetti style of " + style)
		return
	playing_confetti.show()
#	yield(get_tree().create_timer(CONFETTI_SHOW_TIME), "timeout")
##	playing_confetti.emitting = false
##	playing_confetti.hide()
