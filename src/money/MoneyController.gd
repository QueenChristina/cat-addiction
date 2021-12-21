extends Node2D

var money = preload("res://src/money/Money.tscn")

var audio_players = [] # a list of available audio players to play from
var audio_player_index = 0
var money_cling = preload("res://assets/audio/Cling.wav")
var chonk = preload("res://assets/audio/Chonk.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn multiple audio sorces
	for i in range(10):
		audio_players.append(AudioStreamPlayer.new())
		self.add_child(audio_players[i])

func _on_spawn_money():
	var new_money = money.instance()
	new_money.connect("play_sound", self, "_on_play_sound")
	self.add_child(new_money)

func _on_play_sound(type, pitch):
	audio_players[audio_player_index].set_pitch_scale(pitch)
	if type == "money":
		# Money - depreciated, moved to MoneyController.gd
		audio_players[audio_player_index].volume_db = 0
		audio_players[audio_player_index].stream = money_cling
	elif type == "chonk":
		audio_players[audio_player_index].volume_db = -10
		audio_players[audio_player_index].stream = chonk
	else:
		print("ERROR: unknown sound to play: " + type)
	audio_players[audio_player_index].play(0)
	audio_player_index = (audio_player_index + 1) % audio_players.size()
