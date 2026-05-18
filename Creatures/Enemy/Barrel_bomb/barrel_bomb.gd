extends CharacterBody2D

var hp = 5
var friction = 50
var disabled = false
var damage = 8
var undie = false

var coin_scene = preload("res://Creatures/Side_items/coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$ProgressBar.max_value = hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if hp<=0:
		_coins_spawn()
		queue_free()
	$ProgressBar.value = hp
	$ProgressBar2.value = $Timer.time_left
	

func _physics_process(delta):
	velocity = Vector2(move_toward(velocity.x, 0, delta * friction), move_toward(velocity.y, 0, delta * friction))
	move_and_slide()


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")
	var overlapping_bodys = $Area2D2.get_overlapping_bodies()
	for body in overlapping_bodys:
		if body.is_in_group("Player"):
			body._take_damage(damage)
	var overlapping_areas = $Area2D2.get_overlapping_areas()
	for area in overlapping_areas:
		# Проверяем, что это враг (у группы "Enemy")
		var enemy = area.get_parent()
		if enemy.is_in_group("Enemy"):
			enemy.hp -= 10
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.visible = false
	queue_free()

func _coins_spawn():
	var coin = coin_scene.instantiate()
	coin.global_position = global_position
	get_tree().current_scene.add_child(coin)
