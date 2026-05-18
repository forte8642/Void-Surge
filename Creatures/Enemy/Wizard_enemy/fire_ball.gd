extends CharacterBody2D

var damage = 2
var speed = 300.0  # пикселей в секунду
var target_position: Vector2
var _is_flying = false

func _ready():
	pass

func _physics_process(delta):
	if not _is_flying:
		return
	var direction = (target_position - global_position).normalized()
	global_position += direction * speed * delta
	if global_position.distance_to(target_position) < 10:
		queue_free()
	$Icon.rotation += 15

func start_fly(target):
	target_position = target
	_is_flying = true

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage(damage)
	queue_free()
