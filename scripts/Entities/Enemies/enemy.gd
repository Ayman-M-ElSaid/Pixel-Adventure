extends CharacterBody2D
class_name Enemy

signal died
enum Direction {
	LEFT = -1,
	RIGHT = 1,
}

@export var hit_points := 1
@export var gravity := 980.0
@export var direction := Direction.LEFT

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hazard: Area2D = $Hazard

var is_dead := false


func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _on_stomp_area_body_entered(body: CharacterBody2D) -> void:
	if body.velocity.y < 0 or body.global_position.y > global_position.y:
		return
	hazard.set_deferred(&"monitoring", false)
	body.bounce(300)
	hit_points -= 1
	_on_stomp(hit_points)
	if hit_points <= 0:
		die()
		
func _on_stomp_area_body_exited(_body: CharacterBody2D) -> void:
	hazard.set_deferred(&"monitoring", true)

func _on_stomp(_remaining: int) -> void:
	pass


func die() -> void:
	if is_dead:
		return
	is_dead = true
	gravity = 980.0
	hazard.set_deferred(&"monitoring", false)
	animated_sprite.play(&"hit")
	collision.queue_free()
	died.emit()
