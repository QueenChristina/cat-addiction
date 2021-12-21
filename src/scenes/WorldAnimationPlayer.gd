extends AnimationPlayer

onready var tree = $AnimationTree
var state_machine

var intro_seq = ["Intro", "Intro_objective", "Intro_call2action", "Intro_pet"]
var curr_index = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = tree["parameters/playback"]
#	self.play("default") # Delete when ship game. for tutorial

	# UNCOMMENT WHEN SHIP GAME!!! TUTORIAL ... and set Intro animation to <A] autoplay and Tree to active
#func _input(event):
#	if event is InputEventMouse and event.is_action_pressed("click"):
#		if curr_index < intro_seq.size():
#			state_machine.travel(intro_seq[curr_index])
#			curr_index += 1
#		else:
#			pass
#
#func _on_Cat_woke_up():
#	# Score == 1
#	state_machine.travel("Intro_thanks")
#	yield(get_tree().create_timer(1), "timeout")
#
#func _on_Cat_end_tutorial():
#	state_machine.travel("Intro_ending1")
#	tree.active = false
#	self.play("Intro_ending1")
