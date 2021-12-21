extends Area2D

signal woke_up
signal end_tutorial
signal spawn_money(pos)

export var chance_meow = 0.05

var love = preload("res://src/money/Love.tscn")

var in_cat = false
var shake = false setget set_shake
var audio_players = [] # a list of available audio players to play from
var audio_player_index = 0
var chonk = load("res://assets/audio/Chonk.wav")

enum States {IDLE, SHAKING, MEOWING, WALKING}
var state = States.IDLE

# Shake variables.
export(float) var amplitude = 1.0
export(float) var duration = 0.12 setget set_duration # shake time
export(float, EASE) var DAMP_EASING = 3.0

onready var timer = $ShakeTimer
onready var all_sprite = $Base/ShakeBase # Change position of sprite for shaking (default to 0)
onready var hat_decor = $Base/ShakeBase/HatDecor # For shaking separately, (Default to one position)
onready var mouth_decor = $Base/ShakeBase/MouthDecor # For shaking separately, (Default to one position)
onready var body_decor = $Base/ShakeBase/BodyDecor
onready var sprite = $Base/ShakeBase/Sprite
onready var sound_meow = $Mew

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	for i in range(10):
		audio_players.append(AudioStreamPlayer.new())
		self.add_child(audio_players[i])

func _input(event):
#	if Input.is_action_pressed("click"):
	if event is InputEventMouse and event.is_action_pressed("click") and in_cat:
		event = make_input_local(event)
		self.clicky(event.position)
		
func clicky(event_pos, from_autoclicker = false):
	Globals.score += 1
	set_shake(true)
	if from_autoclicker:
		_on_play_sound("chonk", rand_range(0.95, 1.05), -20)
	else:
		_on_play_sound("chonk", rand_range(0.95, 1.05))
	if rand_range(0, 1) < chance_meow and state != States.MEOWING and state != States.WALKING:
		_change_state(States.MEOWING)
	# Spawn love and money
	var new_spark = love.instance()
	new_spark.position = event_pos
	self.add_child(new_spark)
	if rand_range(0, 1) < Globals.chance_get_money:
		emit_signal("spawn_money", event_pos + self.position) # Make position global for money to spawn at point of click
	# Special cases
	if Globals.score == 1 and sprite.animation == "sleep":
		_change_state(States.IDLE)
		emit_signal("woke_up")
	if Globals.score == 30:
		emit_signal("end_tutorial")

func set_shake(value = true):
	shake = value
	if shake:
		_change_state(States.SHAKING)
	else:
		_change_state(States.IDLE)

func _change_state(new_state):
	match new_state:
		States.IDLE:
			all_sprite.position = Vector2(0, 0)
			hat_decor.offset = Vector2(0, 0)
			body_decor.offset = Vector2(0, 0)
			sprite.animation = "stand" # TODO: whatever was previous default animation, eg. walking if animated
			set_process(false)
		States.SHAKING:
			set_process(true)
			timer.start()
		States.MEOWING:
			meow()
		States.WALKING:
			walk()
	state = new_state

func _process(delta):
	var damping = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	all_sprite.position = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)
	hat_decor.offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)
	body_decor.offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)

# Shake based on 
# https://github.com/GDQuest/godot-make-pro-2d-games/blob/master/actors/camera/ShakingCamera.gd
func set_duration(value):
	duration = value
	if not timer:
		return
	timer.wait_time = duration

func _on_ShakeTimer_timeout():
	self.shake = false

func _on_Cat_mouse_entered():
	in_cat = true

func _on_Cat_mouse_exited():
	in_cat = false
	
func _on_play_sound(type, pitch, db = -10):
	audio_players[audio_player_index].set_pitch_scale(pitch)
	if type == "chonk":
		audio_players[audio_player_index].volume_db = db
		audio_players[audio_player_index].stream = chonk
	else:
		print("ERROR: unknown sound to play: " + type)
	audio_players[audio_player_index].play(0)
	audio_player_index = (audio_player_index + 1) % audio_players.size()

func meow():
	sprite.animation = "meow"
	sound_meow.set_pitch_scale(rand_range(1.5, 2))
	sound_meow.play(0)
	
func walk():
	sprite.animation = "walk"
	
func _on_Sprite_animation_finished():
	if sprite.animation == "meow":
		_change_state(States.IDLE)
		all_sprite.scale.x = -1 * all_sprite.scale.x

func _on_equip(item_id, item_type):
	_on_unequip(item_type)
#	print("Equipped " + item_id)
	Globals.equipped[item_type] = item_id
	if item_type == "hat":
		hat_decor.animation = item_id # Assume matches item id
	elif item_type == "mouth":
		mouth_decor.animation = item_id
	elif item_type == "body":
		body_decor.animation = item_id
	else:
		print("EQUIP: did not implement equipping item type " + item_id)

	# Equip status effects
	if Globals.items[item_id].has("dpm_per_sec"):
		print("TODO: increase dpm equip")
		Globals.dpm += Globals.items[item_id]["dpm_per_sec"]

func _on_unequip(item_type):
	var unequipped_id = Globals.equipped[item_type]
	if unequipped_id != "" and Globals.items[unequipped_id].has("dpm_per_sec"):
		# Unequip status effects, and apply any withdrawal
		print("TODO: decrease dpm unequip")
		Globals.dpm -= Globals.items[unequipped_id]["dpm_per_sec"]
#		Globals.dpm -= Globals.items[unequipped_id]["withdrawal"]

	Globals.equipped[item_type] = ""
	if item_type == "hat":
		hat_decor.animation = "default"
	elif item_type == "mouth":
		mouth_decor.animation = "default"
	elif item_type == "body":
		body_decor.animation = "default"
	else:
		print("UNEQUIP: did not implement equipping item type " + item_type)
