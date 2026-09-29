extends CharacterBody2D
class_name Player

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var camera: Camera2D = $Camera

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const MAX_JUMPS = 2
const WALL_GLIDE_GRAVITY_SCALE = 0.3
const WALL_FALL_SPEED = 80
const WALL_JUMP_SPEED = 1000

var direction = 0
var jumps_available := MAX_JUMPS
var is_wall_gliding := false
var is_dead := false
var inventory := []


func _ready() -> void:
	sprite.sprite_frames = Characters.CHARACTERS[SaveManager.data["character"]]
	set_physics_process(false)
	visible = false
	var respawning = PlayerManager.is_respawning
	PlayerManager.is_respawning = false
	if not respawning:
		await Transition.wipe_out_finished
	visible = true
	sprite.play(&"appear")
	await sprite.animation_finished
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	direction = Input.get_axis(&"move_left", &"move_right")
	is_wall_gliding = (
		is_on_wall_only() and direction * get_wall_normal().x < 0 and velocity.y >= 0
	)

	if is_on_floor():
		jumps_available = MAX_JUMPS
	elif is_wall_gliding:
		velocity.y += get_gravity().y * WALL_GLIDE_GRAVITY_SCALE * delta
		velocity.y = min(velocity.y, WALL_FALL_SPEED)
		jumps_available = MAX_JUMPS
	else:
		velocity += get_gravity() * delta

	if is_dead:
		move_and_slide()
		return

	if Input.is_action_just_pressed(&"jump") and jumps_available > 0:
		jump_sound.play()
		velocity.y = JUMP_VELOCITY
		jumps_available -= 1
		if is_wall_gliding:
			velocity.x = get_wall_normal().x * WALL_JUMP_SPEED
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	_handle_animation()
	move_and_slide()


func _handle_animation() -> void:
	if is_on_floor():
		if direction == 0:
			sprite.play(&"idle")
		else:
			sprite.play(&"run")
	elif is_wall_gliding:
		sprite.play(&"wall_glide")
	else:
		if velocity.y >= 0:
			sprite.play(&"jump")
		elif jumps_available == 0:
			sprite.play(&"double_jump")
		else:
			sprite.play(&"fall")

	if is_wall_gliding:
		sprite.position.x = sign(direction) * 4
	else:
		sprite.position.x = 0

	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true


func bounce(bounce_force: float) -> void:
	velocity.y = -bounce_force
	jump_sound.play()


func die() -> void:
	if is_dead:
		return
	PlayerManager.is_respawning = true
	camera.shake(5)
	is_dead = true
	hit_sound.play()
	sprite.play(&"hit")
	collision.queue_free()
	SaveManager.data["death_count"] += 1
	SaveManager.save_game()

	if not inventory.size():
		return
	var dropped_item_count = clamp(10 * (1 - exp(-inventory.size() / 14.0)), 0, 10)
	for i in range(dropped_item_count + randf_range(-.5, .5)):
		var item: Debris = preload("res://scenes/Entities/debris.tscn").instantiate()
		var selection = inventory.pick_random()
		inventory.erase(selection)
		item.sprite = Collectable.FRAMES[Collectable.Fruit[selection]].get_frame_texture(
			&"fruit",
			0,
		)
		item.sprite_region = Rect2(0, 0, 32, 32)
		call_deferred(&"add_child", item)
		item.activate.call_deferred(
			Vector2(randi_range(-100, 100), randi_range(-300, -200)),
			randi_range(-5, 5),
		)
		(func():
			item.collision.set_deferred(&"disabled", true)
		).call_deferred()


func disappear() -> void:
	collision.queue_free()
	set_physics_process(false)
	sprite.play(&"disappear")
	await sprite.animation_finished
