extends Node2D

@export_file("*.tscn") var win_scene_path: String = "res://Winscene.tscn"

@onready var timer: Timer = $Timer
@onready var countdown_label: Label = $Countdown   

func _ready() -> void:
	# 60-second survival timer
	timer.one_shot = true
	timer.wait_time = 60.0
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	_update_label(timer.wait_time)

func _process(_delta: float) -> void:
	# Update the countdown every frame
	if is_instance_valid(countdown_label):
		_update_label(timer.time_left)

func _update_label(seconds_left: float) -> void:
	var s := int(ceil(max(0.0, seconds_left)))
	var mm := int(s /60)
	var ss := s % 60
	countdown_label.text = "%02d:%02d" % [mm, ss]   

func _on_timer_timeout() -> void:
	# Survived the minute than load Win scene
	if win_scene_path != "":
		get_tree().change_scene_to_file(win_scene_path)
