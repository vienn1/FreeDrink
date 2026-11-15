extends CharacterBody2D

@export var speed: float = 100.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction := Vector2.ZERO
var next_direction := Vector2.ZERO


func _physics_process(_delta: float) -> void:
	read_input()

	if next_direction != Vector2.ZERO and next_direction != direction:
		if not test_move(global_transform, next_direction * 2.0):
			direction = next_direction

	velocity = direction * speed
	move_and_slide()

	update_animation()


func read_input() -> void:
	var input := Input.get_vector("moveleft", "moveright", "movefront", "moveback")
	if input == Vector2.ZERO:
		return
	if absf(input.x) > absf(input.y):
		next_direction = Vector2(signf(input.x), 0.0)
	else:
		next_direction = Vector2(0.0, signf(input.y))


func update_animation() -> void:
	match direction:
		Vector2.UP:
			sprite.animation = "Front"
		Vector2.DOWN:
			sprite.animation = "Back"
		Vector2.LEFT:
			sprite.animation = "Left"
		Vector2.RIGHT:
			sprite.animation = "Right"

	if velocity.length() > 1.0:
		if not sprite.is_playing():
			sprite.play()
	else:
		sprite.pause()
