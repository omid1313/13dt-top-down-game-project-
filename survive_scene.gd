extends Node2D

# The scene that loads when the player survives (win condition)
@export_file("*.tscn") var win_scene_path: String = "res://Winscene.tscn"

# References to nodes in the scene
@onready var timer: Timer = $Timer
@onready var countdown_label: Label = $Countdown


# Called once when the scene starts
# Sets up a 60-second timer and connects it to the timeout function
func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = 60.0
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	_update_label(timer.wait_time)



# Updates the countdown display every frame while the timer is running
func _process(_delta: float) -> void:
	if is_instance_valid(countdown_label):
		_update_label(timer.time_left)



# Updates the label text to show the time left in minutes and seconds
func _update_label(seconds_left: float) -> void:
	var s := int(ceil(max(0.0, seconds_left)))
	var mm := int(s / 60)
	var ss := s % 60
	countdown_label.text = "%02d:%02d" % [mm, ss]



# Called when the timer finishes
# If the player survives for 60 seconds, it switches to the win scene
func _on_timer_timeout() -> void:
	if win_scene_path != "":
		get_tree().change_scene_to_file(win_scene_path)
