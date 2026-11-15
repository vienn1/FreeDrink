extends CharacterBody2D

const DIRECTIONS: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

@export var speed: float = 80.0
@export var lookahead: float = 16.0
@export_range(0.0, 1.0) var randomness: float = 0.1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: Node2D
var direction := Vector2.ZERO
var last_open: Array[Vector2] = []


func _ready() -> void:
	find_player()


func _physics_process(_delta: float) -> void:
	if player == null or not is_instance_valid(player):
		find_player()

	update_direction()

	velocity = direction * speed
	move_and_slide()

	update_animation()


func find_player() -> void:
	player = get_tree().current_scene.find_child("Player", true, false) as Node2D


func get_open_directions() -> Array[Vector2]:
	var open: Array[Vector2] = []
	for dir in DIRECTIONS:
		if not test_move(global_transform, dir * 2.0):
			open.append(dir)
	return open


func update_direction() -> void:
	var open := get_open_directions()
	var must_decide := direction == Vector2.ZERO or open != last_open or not open.has(direction)
	last_open = open

	if must_decide:
		direction = choose_direction(open)


func choose_direction(open: Array[Vector2]) -> Vector2:
	if open.is_empty():
		return Vector2.ZERO

	var options: Array[Vector2] = open.duplicate()
	if options.size() > 1:
		options.erase(-direction)

	if player == null or randf() < randomness:
		return options.pick_random()

	var best: Vector2 = options[0]
	var best_distance := INF
	for dir in options:
		var distance: float = (global_position + dir * lookahead).distance_to(player.global_position)
		if distance < best_distance:
			best_distance = distance
			best = dir
	return best


func update_animation() -> void:
	match direction:
		Vector2.UP:
			sprite.animation = "default"
		Vector2.DOWN:
			sprite.animation = "default"
		Vector2.LEFT:
			sprite.animation = "default"
		Vector2.RIGHT:
			sprite.animation = "default"

	if velocity.length() > 1.0:
		if not sprite.is_playing():
			sprite.play()
	else:
		sprite.pause()
