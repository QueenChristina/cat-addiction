extends AnimatedSprite

# TODO: make

# Called when the node enters the scene tree for the first time.
var t=0
func _ready():
	pass # Replace with function body.
func _process(delta):
	t+=delta
	var n=get_node("../Cat")
	var dis=sin(10*t)*10+30
	scale=Vector2(1,1)*(3-sin(10*t))/10
	rotation=t-PI/4
	position=Vector2(cos(t)*dis,sin(t)*dis)+n.position

func _on_Timer_timeout():
	Globals.score += 1
