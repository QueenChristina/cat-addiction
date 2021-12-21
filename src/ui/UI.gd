extends CanvasLayer

onready var label_score = $Margin/Scores/Score
onready var label_money = $Margin/Scores/Money
onready var label_dpm = $Margin/Scores/dpm_per_sec

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
var prev_score = 0
var t = 0
var last_t = 0
var dpm = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label_score.text = str(Globals.score) # TODO: use signals + tween animate instead
	label_money.text = "$" + str(Globals.bank) # TODO: use signals + tween animate instead
	# Calculate real dpm with clickers
#	var additional_dpm = Globals.inventory["clicker"] * Globals.clicker_hz
#	label_dpm.text = str(Globals.dpm + additional_dpm) + " dpm/s"

	# Calculate average real dpm including player click rate
	t += delta
	if (t - last_t) > 1:
		last_t = t
		dpm = (Globals.score - prev_score) / 1
		prev_score = Globals.score
	label_dpm.text = str(dpm) + " dpm/s"
