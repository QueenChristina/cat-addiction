extends Node2D

# Increases dopamine per second based on Globals.dpm and equipped items/effects
# Also handles visual effects of withdrawal, etc.

onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	if Globals.dpm != 0:
		Globals.score += Globals.dpm
	if Globals.dpm > 0:
		# happy
		anim.play("happy")
	elif Globals.dpm < 0: # TODO: use epsilon instead, or extra modulate color intensity -- different DEGREES
		# hurt
		anim.play("hurt")
	else:
		# neutral
		anim.play("neutral")
