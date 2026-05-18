extends CharacterBody2D

const RANGE_ATTACK = 18

var hp = 3

var disabled = false
var attack = false

var damage = 1

const SPEED = 100.0

var undie = false

@onready var Player := $"../Player"
var walk = false

var coin_scene = preload("res://Creatures/Side_items/coin.tscn")

func _ready() -> void:
	$ProgressBar.max_value = hp

func _process(_delta: float) -> void:
	if hp <= 0:
		_coins_spawn()
		queue_free()
	$ProgressBar.value = hp
	
	if is_instance_valid(Player):
		if position.distance_to(Player.position) < RANGE_ATTACK and attack == false:
			attack = true
			_attack()
	if attack == true:
		velocity = Vector2(0, 0)

func _physics_process(_delta: float) -> void:
	if is_instance_valid(Player):
		if disabled == false and attack == false:
			_walk()
		
	move_and_slide()

func _walk():
	if attack == false:
		var direction_attack = (Player.position - self.position).normalized()
		velocity = direction_attack * SPEED

func _attack():
	$attack2.monitoring = true
	$attack2/AttackAnimation2.visible = true
	$attack2/AttackAnimation2.play("default")
	await get_tree().create_timer(0.1).timeout
	$attack2.monitoring = false
	$attack2/AttackAnimation2.visible = false
	await get_tree().create_timer(0.5).timeout
	$attack1.monitoring = true
	$attack1/AttackAnimation1.visible = true
	$attack1/AttackAnimation1.play("default")
	await get_tree().create_timer(0.1).timeout
	$attack1.monitoring = false
	$attack1/AttackAnimation1.visible = false
	attack = false



func _on_attack_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body._take_damage(damage)


func _on_attack_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body._take_damage(damage)

func _coins_spawn():
	var coin = coin_scene.instantiate()
	coin.global_position = global_position
	get_tree().current_scene.add_child(coin)
