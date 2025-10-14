extends CharacterBody2D

@export var speed: float = 90.0
@export var direction: int = -1                  # start moving left
@export var anim_name: StringName = "fly"        # animation name
@export var sprite_faces_right: bool = false     # false = sprite faces left by default

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Ensure direction is valid
	if direction >= 0:
		direction = 1
	else:
		direction = -1

	# Start animation
	if sprite and anim_name != "":
		sprite.play(anim_name)

# Controls the bee’s movement and flips its direction when it hits a wall.
func _physics_process(delta: float) -> void:
	velocity.x = speed * direction
	velocity.y = 0.0
	move_and_slide()

	# Reverse direction when hitting a wall
	if is_on_wall():
		direction *= -1
		position.x += 2.0 * direction  # small push to prevent sticking

	# Flip sprite to face correct direction
	if sprite_faces_right:
		sprite.flip_h = direction < 0
	else:
		sprite.flip_h = direction > 0

	# Keep animation playing
	if sprite and not sprite.is_playing():
		sprite.play(anim_name)

#  Damage player on collision.
func _on_body_die_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(1)









	
