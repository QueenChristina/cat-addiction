extends CanvasLayer

onready var label_score = $Margin/Scores/Score
onready var label_money = $Margin/Scores/Money

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label_score.text = str(Globals.score) # TODO: use signals + tween animate instead
	label_money.text = "$" + str(Globals.bank) # TODO: use signals + tween animate instead
