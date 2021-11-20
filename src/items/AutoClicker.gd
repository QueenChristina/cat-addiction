extends AnimatedSprite

# TODO: make

# Called when the node enters the scene tree for the first time.
var t=rand_range(0,2*PI)
func _ready():
	pass # Replace with function body.
func _process(delta):
	if(floor((t/(2*PI))*10)!=floor(((t+delta)/(2*PI))*10)):
		var n=get_node("../Cat")
		n.clicky(n.to_local(self.to_global(Vector2(0,0))))
	t+=delta
	var n=get_node("../Cat")
	var dis=-cos(10*t)*10+30
	scale=Vector2(1,1)*(3+cos(10*t))/10
	rotation=t-PI/4
	position=Vector2(cos(t)*dis,sin(t)*dis)+n.position
