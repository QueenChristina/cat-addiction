extends AnimatedSprite

export var speed = 2
var transparent = 1
var fade = 0.015

onready var Sound = $Sound
onready var tweenMod = $Tween

#func _ready():
#	Sound.stream = load("res://Audio/Chonk.wav")
#	hide() 

func _ready():
	Sound.play()
	# tween to nothingness
	tweenMod.interpolate_property(self, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweenMod.start()

func _process(delta):
	self.position.y = self.position.y - speed
	speed = speed + speed * delta

func _on_screen_exited():
	self.queue_free()
