extends Area2D

export var chance_meow = 0.05

var love = preload("res://src/money/Love.tscn")
var money = preload("res://src/money/Money.tscn")

var in_cat = false
var shake = false setget set_shake
var audio_players = [] # a list of available audio players to play from
var audio_player_index = 0
var money_cling = load("res://assets/audio/Cling.wav")
var chonk = load("res://assets/audio/Chonk.wav")

enum States {IDLE, SHAKING, MEOWING}
var state = States.IDLE
var default_hat_decor_pos

# Shake variables.
export(float) var amplitude = 1.0
export(float) var duration = 0.12 setget set_duration # shake time
export(float, EASE) var DAMP_EASING = 3.0

onready var timer = $ShakeTimer
onready var all_sprite = $Base/ShakeBase # Change position of sprite for shaking (default to 0)
onready var hat_decor = $Base/ShakeBase/HatDecor # For shaking separately, (Default to one position)
onready var mouth_decor = $Base/ShakeBase/MouthDecor # For shaking separately, (Default to one position)
onready var sprite = $Base/ShakeBase/Sprite
onready var sound_meow = $Mew

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	default_hat_decor_pos = hat_decor.position
	print(default_hat_decor_pos)
	for i in range(10):
		audio_players.append(AudioStreamPlayer.new())
		self.add_child(audio_players[i])

func _input(event):
#	if Input.is_action_pressed("click"):
	if event is InputEventMouse and event.is_action_pressed("click") and in_cat:
		Globals.score += 1
		set_shake(true)
		_on_play_sound("chonk", rand_range(0.95, 1.05))
		if rand_range(0, 1) < chance_meow and state != States.MEOWING:
			_change_state(States.MEOWING)
		# Spawn love and money
		var new_spark = love.instance()
		event = make_input_local(event)
		new_spark.position = event.position
		self.add_child(new_spark)
		if rand_range(0, 1) < Globals.chance_get_money:
			var new_money = money.instance()
			new_money.connect("play_sound", self, "_on_play_sound")
			self.add_child(new_money)

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
			hat_decor.position = default_hat_decor_pos
			sprite.animation = "stand" # TODO: whatever was previous default animation, eg. walking if animated
			set_process(false)
		States.SHAKING:
			set_process(true)
			timer.start()
		States.MEOWING:
			meow()
	state = new_state

func _process(delta):
	var damping = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	all_sprite.position = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)
	hat_decor.position = Vector2(
		rand_range(amplitude, -amplitude) * damping + default_hat_decor_pos.x,
		rand_range(amplitude, -amplitude) * damping + default_hat_decor_pos.y)

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
	
func _on_play_sound(type, pitch):
	audio_players[audio_player_index].set_pitch_scale(pitch)
	if type == "money":
		audio_players[audio_player_index].volume_db = 0
		audio_players[audio_player_index].stream = money_cling
	elif type == "chonk":
		audio_players[audio_player_index].volume_db = -10
		audio_players[audio_player_index].stream = chonk
	else:
		print("ERROR: unknown sound to play: " + type)
	audio_players[audio_player_index].play(0)
	audio_player_index = (audio_player_index + 1) % audio_players.size()

func meow():
	sprite.animation = "meow"
	sound_meow.set_pitch_scale(rand_range(1.5, 2))
	sound_meow.play(0)
	
func _on_Sprite_animation_finished():
	if sprite.animation == "meow":
		_change_state(States.IDLE)
		all_sprite.scale.x = -1 * all_sprite.scale.x

func _on_equip(item_id, item_type):
	if item_type == "hat":
		hat_decor.animation = item_id # Assume matches item id
	elif item_type == "mouth":
		mouth_decor.animation = item_id

func _on_unequip(item_type):
	if item_type == "hat":
		hat_decor.animation = "default"
	elif item_type == "mouth":
		mouth_decor.animation = "default"
