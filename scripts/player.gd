extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var hit_sound = $HitSound

var is_dead := false


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_dead:
		move_and_slide()
		return

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")

	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
	else:
		if velocity.y >= 0:
			sprite.play("jump")
		else:
			sprite.play("fall")

	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func die():
	if is_dead:
		return
	is_dead = true
	hit_sound.play()
	sprite.play("hit")
	collision.queue_free()
