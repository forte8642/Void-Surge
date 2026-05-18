extends Node2D

@onready var Super_attack_chargeindicator = $CanvasLayer/Super_attack_charger
@onready var Wave_chargeindicator = $CanvasLayer/Wave_charger
@onready var Hp_player_bar = $CanvasLayer/Player_hp_bar
@onready var Player = $Player

var enemy = [] 
@onready var Wizard_enemy = preload("res://Creatures/Enemy/Wizard_enemy/wizard_enemy.tscn")
@onready var Healing_arrow = preload("res://Creatures/Side_items/Healing_arrow.tscn")
@onready var Base_enemy = preload("res://Creatures/Enemy/Base_enemy/base_enemy.tscn")
@onready var Barrel_enemy = preload("res://Creatures/Enemy/Barrel_bomb/barrel_bomb.tscn")

var riptide = 5

var timer = 60

var calmly = true

var shop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(Player):
		Super_attack_chargeindicator.max_value = Player.max_charge
		Wave_chargeindicator.max_value = Player.wave_max_charge
		Hp_player_bar.max_value = Player.MAX_HP
	enemy = [Healing_arrow, Barrel_enemy, Wizard_enemy, Base_enemy]
	$Riptide_Timer.wait_time = timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_instance_valid(Player):
		Super_attack_chargeindicator.value = Player.charge_value
		Wave_chargeindicator.value = Player.wave_charge_value
		Hp_player_bar.value = Player.hp
	$CanvasLayer/Riptide_timer.text = str(round($Riptide_Timer.time_left))
	
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.size() > 0:
		calmly = false
	else:
		calmly = true
	
	$CanvasLayer/Money.text = "Монеты: " + str( God.coins)
	
	if is_instance_valid(Player):
		if shop == false:
			Player.unable = false
		elif shop == true:
			Player.unable = true

func _enemy_wave(Full_enemy):
	for i in riptide:
		for enemy_namber in Full_enemy.size():
			var enemy_now = Full_enemy[enemy_namber].instantiate()
			if enemy_namber < 2:
				enemy_now.global_position = Vector2(randi_range(20, 2275), randi_range(25, 1285))
			else:
				enemy_now.global_position = Vector2(randi_range(-50, 2350), [-50, 1350].pick_random())
			get_tree().current_scene.add_child(enemy_now)


func _on_timer_timeout() -> void:
	_enemy_wave(enemy)

func _check_buff():
	for item_check in God.items.size():
		if God.items[item_check] == God.Sacred_Hammer:
			Player.player_damage = 3
		if God.items[item_check] == God.Walking_boots:
			Player.speed_buff = 100
		if God.items[item_check] == God.Long_handle:
			Player.attack_buff = true
		if God.items[item_check] == God.Speed_Mantle:
			Player.charge_buff = 33
