extends Node2D
"""
Manages reacting to achievements by:
	- sending achievement notification
	- adding achivements to container.
"""
export var NOTIFICATION_SHOW_TIME = 2 # time in seconds for notification to show

onready var all_achievements = $PastAchievements # A container for achievements_container
onready var achievements_container = $PastAchievements/ScrollContainer/VBoxContainer
onready var achievement_item = preload("res://src/ui/Achievement.tscn")
onready var confetti = $Confetti
onready var cheer = $Cheers

onready var notification = $Notification

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("achievement_reached", self, "_on_achievement_reached")

func _on_achievement_reached(id):
	# Add achievement to the list
	var a_name = Globals.achievements[id]["name"]
	var description = Globals.achievements[id]["description"]
	var style = Globals.achievements[id]["icon"]
	var confetti_style = ""
	if Globals.achievements[id].has("confetti"):
		confetti_style = Globals.achievements[id]["confetti"]
	# TODO: instead of an icon, change background panel style / color
	var achievement = achievement_item.instance()
	achievements_container.add_child(achievement)
	achievement.init(a_name, description, style)
	
	# Show a notification and celebrate
	if (!all_achievements.visible):
		# Set notificaton stuff TODO: use icon for something
		notification.init(a_name, description, style)

		# Do special effects
		confetti.play(confetti_style)
		
		# Play relevant sound TODO: add more preloaded sounds
		cheer.play(0)
