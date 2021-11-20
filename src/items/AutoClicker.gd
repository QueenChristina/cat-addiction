extends AnimatedSprite

var cat = null

# Called when the node enters the scene tree for the first time.
var click_hz=2
var t=rand_range(0,1)
var last_click_t=t+0
func _ready():
	self.last_click_t=t+0
	pass # Replace with function body.
func set_cat(new_cat):
	cat=new_cat
func _process(delta):
	if cat!=null:
		t+=delta
		if t-last_click_t>1.0/click_hz:
			self.last_click_t=self.last_click_t+1.0/click_hz
			cat.clicky(cat.to_local(self.to_global(Vector2(0,0))))
		var click_ler=(t-last_click_t)*click_hz
		var radius=-cos(click_ler*2*PI)*10+30
		scale=Vector2(1,1)*(3+cos(click_ler*2*PI))/10
		rotation=t-PI/4
		position=Vector2(cos(t)*radius,sin(t)*radius)+cat.to_global(Vector2(0,0))
