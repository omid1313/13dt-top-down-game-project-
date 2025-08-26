extends Node2D

@onready var particles = $GPUParticles2D
@onready var area = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var timer = $Timer
var is_hidden = false

func toggle_visibility():
# If the object is currently hidden (is_hidden is true)
	if is_hidden:
		particles.visible = true
		area.visible = true
		collision_shape.disabled = false
	else:
		particles.visible = false
		area.visible = false
		collision_shape.disabled = true

	is_hidden = !is_hidden  # Switch between hidden and visible states
	timer.start()  # Restart the timer


func _ready():
 # Set the timer's wait time to 3 seconds before triggering the timeout
	timer.wait_time = 1000
	timer.start()
	timer.connect("timeout", Callable(self, "toggle_visibility"))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene() 
