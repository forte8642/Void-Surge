extends CharacterBody2D

const SPEED = 100.0

var hp = 2
var attack = false
var disabled = false
var RANGE_ATTACK = 300
var undie = false
var fire_ball_nomber = 3
var direction_attack

var coin_scene = preload("res://Creatures/Side_items/coin.tscn")

@onready var fire_ball := preload("res://Creatures/Enemy/Wizard_enemy/fire_ball.tscn")
@onready var Player := $"../Player"

func _ready():
	$ProgressBar.max_value = hp
	$AttackTimer.timeout.connect(_reset_attack)

func _process(_delta):
	if hp <= 0:
		_coins_spawn()
		queue_free()
	$ProgressBar.value = hp
	
	if is_instance_valid(Player):
		if position.distance_to(Player.position) < RANGE_ATTACK and attack == false and $AttackTimer.is_stopped():
			attack = true
			_attack()
			$AttackTimer.start()
	if attack == true:
		velocity = Vector2(0, 0)

func _physics_process(_delta: float) -> void:
	if is_instance_valid(Player):
		if disabled == false and attack == false:
			_walk()
	
	move_and_slide()

func _walk():
	direction_attack = (Player.position - position).normalized()
	velocity = direction_attack * SPEED

func _attack():
	for i in fire_ball_nomber:
		var fire_balls = fire_ball.instantiate()
		fire_balls.global_position = global_position + Vector2(-50 + 50 * i, -30)
		fire_balls.start_fly(Player.global_position)
		get_tree().current_scene.add_child(fire_balls)

func _reset_attack():
	attack = false

func _coins_spawn():
	var coin = coin_scene.instantiate()
	coin.global_position = global_position
	get_tree().current_scene.add_child(coin)
