extends AnimatedSprite

var cat = null

var click_hz = 2 # NOTE: overriden by Globals.clicker_hz for upgradeability
var t = rand_range(0,1)
var last_click_t = t + 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.last_click_t = t + 0
	
func set_cat(new_cat):
	cat = new_cat

func _process(delta):
	if cat != null:
		click_hz = Globals.clicker_hz
		
		t += delta
		if t - last_click_t > 1.0 / click_hz:
			self.last_click_t = self.last_click_t + 1.0 / click_hz
			cat.clicky(cat.to_local(self.to_global(Vector2(0,0))), true)

		var click_ler = (t-last_click_t) * click_hz
		var radius =- cos(click_ler * 2 * PI) * 10 + 30
		scale = Vector2(1,1) * (3 + cos(click_ler * 2 * PI))/10
		rotation = t - PI/4
		position = Vector2(cos(t) * radius, sin(t) * radius) + cat.to_global(Vector2(0,0))
