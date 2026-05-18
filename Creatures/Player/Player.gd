extends CharacterBody2D

# Константы
const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const FRICTION = 50
const DEFAULT_FONT_SIZE = 16
const ATTACK_FONT_SIZE = 32
const MAX_HP = 8

# Зарядка
var charge_value = 0
var max_charge = 100

var wave_charge_value = 0
var wave_max_charge = 100

# Подгружаемые объекты и ноды
var move_particles = preload("res://Creatures/Player/prticles.tscn")
@onready var Damag_Counter = $Damag_Label

# Переменные отвечающии за атаку и её направление
var attack = false
var super_attack = false
var previous_direction: Vector2
var mouse_direction: Vector2
var player_damage = 1
var buff_player_damage = 1

# Переменные отвечающии за показатели персонажа
var acceleration = 2 # Ускорение
var hp = 8 # Здоровье
var andie = false # Период бессмертия после получения урона
var disable = false # Персонаж не может двигаться 
var blink = false
var unable = false
var speed_buff = 0
var attack_buff = false
var charge_buff = 0

# Переменные отвичающии за партиклы
var PARTICLE_INTERVAL = 0.02
var last_particle_time = 0

func _physics_process(delta: float) -> void:
	
	if hp <= 0:
		queue_free()
	if unable == false:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var directionX := Input.get_axis("ui_left", "ui_right")
		var directionY := Input.get_axis("ui_up", "ui_down")
		var move := Vector2(directionX, directionY)
		
		Damag_Counter.text = str(player_damage * buff_player_damage)
		
		if move and disable == false:
			if Time.get_ticks_msec() - last_particle_time > PARTICLE_INTERVAL * 1000:
				_move_particles()
				last_particle_time = Time.get_ticks_msec()
			velocity = move.normalized() * (SPEED * acceleration + speed_buff)
			previous_direction = velocity
			if attack == false:
				_Animated(move, "Run_Right", "Run_Left", "Run_Up", "Run_Down")
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION)
			velocity.y = move_toward(velocity.y, 0, FRICTION)
			if attack == false:
				_Animated(previous_direction, "Idle_Right", "Idle_Left", "Idle_Up", "Idle_Down")
		if attack == false:
			if Input.is_action_just_pressed("ui_mouse_left"):
				attack = true
				var attack_dir = _attack_direction()  # Vector2(1,0), (-1,0), (0,1) или (0,-1)
				if super_attack == false:
					_Animated(attack_dir, "Attack_Right", "Attack_Left", "Attack_Up", "Attack_Down")
					buff_player_damage = 1
					$AnimatedSprite2D.self_modulate = Color(1.0, 1.0, 1.0, 1.0)  # Красноватый оттенок
				elif super_attack == true:
					disable = true
					andie = true
					_Animated(attack_dir, "Super_Attack_Right", "Super_Attack_Left", "Super_Attack_Up", "Super_Attack_Down")
					buff_player_damage = 2
					$AnimatedSprite2D.self_modulate = Color(1, 0.5, 0.5)  # Красноватый оттенок
					var dash_dir = _dash()
					velocity = dash_dir * 1250
				if attack_dir.x > 0:
					$AreaAttackRight.monitoring = true
				elif attack_dir.x < 0:
					$AreaAttackLeft.monitoring = true
				elif attack_dir.y > 0:
					$AreaAttackDown.monitoring = true
				elif attack_dir.y < 0:
					$AreaAttackUp.monitoring = true
				await $AnimatedSprite2D.animation_finished
				$AreaAttackRight.monitoring = false
				$AreaAttackLeft.monitoring = false
				$AreaAttackDown.monitoring = false
				$AreaAttackUp.monitoring = false
				attack = false
				super_attack = false
				disable = false
				andie = false
				Damag_Counter.visible = false
				Damag_Counter.add_theme_font_size_override("font_size", DEFAULT_FONT_SIZE)
			acceleration = 2
			PARTICLE_INTERVAL = 0.02
			
		elif super_attack != true:
			acceleration = 0.5
			PARTICLE_INTERVAL = 0.1
		
		if Input.is_action_pressed("ui_mouse_left") and attack == false and super_attack == false:
			charge_value += delta * (100 + charge_buff)
			if charge_value >= max_charge:
				super_attack = true
				charge_value = 0
		
		if Input.is_action_just_released("ui_mouse_left"):
			charge_value = 0
		
		if super_attack == true:
			$AnimatedSprite2D.self_modulate = Color(super_attack, 0.5, 0.5)  # Красноватый оттенок
			charge_value = 0
			acceleration = 3
		else:
			$AnimatedSprite2D.self_modulate = Color(1.0, 1.0, 1.0, 1.0)  # Красноватый оттенок
		
		if Input.is_action_pressed("ui_mouse_right") and attack == false and super_attack == false:
			wave_charge_value += delta * 100
			if wave_charge_value >= wave_max_charge:
				$AnimatedWave.visible = true
				$AnimatedWave.play("default")
				_apply_repulsion_wave()
				wave_charge_value = 0
				await $AnimatedWave.animation_finished
				$AnimatedWave.visible = false
		else:
			wave_charge_value = 0
		
		if blink == false:
			$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		if attack_buff == false:
			$AreaAttackLeft/CollisionShape2D.disabled = false
			$AreaAttackRight/CollisionShape2D.disabled = false
			$AreaAttackUp/CollisionShape2D.disabled = false
			$AreaAttackDown/CollisionShape2D.disabled = false
			$AreaAttackLeft/CollisionShape2D2.disabled = true
			$AreaAttackRight/CollisionShape2D2.disabled = true
			$AreaAttackUp/CollisionShape2D2.disabled = true
			$AreaAttackDown/CollisionShape2D2.disabled = true
		elif attack_buff == true:
			$AreaAttackLeft/CollisionShape2D.disabled = true
			$AreaAttackRight/CollisionShape2D.disabled = true
			$AreaAttackUp/CollisionShape2D.disabled = true
			$AreaAttackDown/CollisionShape2D.disabled = true
			$AreaAttackLeft/CollisionShape2D2.disabled = false
			$AreaAttackRight/CollisionShape2D2.disabled = false
			$AreaAttackUp/CollisionShape2D2.disabled = false
			$AreaAttackDown/CollisionShape2D2.disabled = false
		
		move_and_slide()

func _Animated(direction, animation_right, animation_left, animation_up, animation_down):
	var anim_name = ""
	if direction.x > 0:
		anim_name = animation_right
	elif direction.x < 0:
		anim_name = animation_left
	elif direction.y > 0:
		anim_name = animation_down
	elif direction.y < 0:
		anim_name = animation_up
	else:
		anim_name = animation_down # default
	$AnimatedSprite2D.play(anim_name)

func _on_area_attack_left_area_entered(area: Area2D) -> void:
	if area.name == "take_damage_area":
		if area.get_parent().is_in_group("Enemy"):
			_inflict_damage(area.get_parent())
			_start_damage_display()

func _on_area_attack_right_area_entered(area: Area2D) -> void:
	if area.name == "take_damage_area":
		if area.get_parent().is_in_group("Enemy"):
			_inflict_damage(area.get_parent())
			_start_damage_display()

func _on_area_attack_up_area_entered(area: Area2D) -> void:
	if area.name == "take_damage_area":
		if area.get_parent().is_in_group("Enemy"):
			_inflict_damage(area.get_parent())
			_start_damage_display()

func _on_area_attack_down_area_entered(area: Area2D) -> void:
	if area.name == "take_damage_area":
		if area.get_parent().is_in_group("Enemy"):
			_inflict_damage(area.get_parent())
			_start_damage_display()

func _attack_direction():
	mouse_direction = get_global_mouse_position()
	var player_position = global_position
	var dir_to_mouse = (mouse_direction - player_position).normalized()
	if abs(dir_to_mouse.x) > abs(dir_to_mouse.y):
		return Vector2(sign(dir_to_mouse.x), 0)
	else:
		return Vector2(0, sign(dir_to_mouse.y))# Вертикальное

func _move_particles():
	var particles = move_particles.instantiate()
	var origin = Vector2(randi_range(int(self.position.x) - 10, int(self.position.x) + 10), randi_range(int(self.position.y) + 23, int(self.position.y) + 43)) # Находим позицию, на которой будут спавниться партиклы
	
	particles.position = origin # Задаём позицию партиклам
	
	particles.lifetime = 0.1
	
	get_tree().current_scene.add_child(particles) # Создаём партиклы в дереве персонажа
	
	particles.emitting = true

func _start_damage_display():
	Damag_Counter.visible = true
	Damag_Counter.add_theme_font_size_override("font_size", DEFAULT_FONT_SIZE)
	var tween = create_tween()
	tween.tween_method(_update_font_size, DEFAULT_FONT_SIZE, ATTACK_FONT_SIZE, 0.2)
	# После атаки скроем и сбросим размер (можно и отдельным твином)

func _update_font_size(value):
	Damag_Counter.add_theme_font_size_override("font_size", int(value))

func _dash():
	var mouse_direction_dash = get_global_mouse_position()
	var player_position_dash = self.global_position
	var dir_to_mouse_dash = (mouse_direction_dash - player_position_dash).normalized()
	if abs(dir_to_mouse_dash.x) > abs(dir_to_mouse_dash.y):
		return Vector2(sign(dir_to_mouse_dash.x), 0)
	else:
		return Vector2(0, sign(dir_to_mouse_dash.y))# Вертикальное

func _apply_repulsion_wave():
	# Получаем все Area2D внутри нашей зоны
	var overlapping_areas = $AreaRepulseWave.get_overlapping_areas()
	for area in overlapping_areas:
		# Проверяем, что это враг (у группы "Enemy")
		var enemy = area.get_parent()
		if enemy.is_in_group("Enemy"):
				var dir = (enemy.position - position).normalized()
				enemy.velocity = dir * 200  # скорость 200 пикселей/сек
				enemy.disabled = true
				_reset_disabled_after_delay(enemy)

func _reset_disabled_after_delay(enemy):
	await get_tree().create_timer(1).timeout
	if is_instance_valid(enemy):
		enemy.disabled = false

func _take_damage(damage):
	if andie == false:
		hp -= damage
		andie = true
		_blink_sprite(Color(1, 0.3, 0.3))
		await get_tree().create_timer(1).timeout
		andie = false

func _blink_sprite(color):
	blink = true
	var original_color = $AnimatedSprite2D.modulate
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", color, 0.1)
	tween.tween_property($AnimatedSprite2D, "modulate", original_color, 0.1)
	tween.tween_property($AnimatedSprite2D, "modulate", color, 0.1)
	tween.tween_property($AnimatedSprite2D, "modulate", original_color, 0.1)
	await tween.finished
	blink = false

func _inflict_damage(enemy):
	if not is_instance_valid(enemy):
		return
	if enemy.undie == false:
		enemy.hp -= player_damage * buff_player_damage
		enemy.undie = true
		await $AnimatedSprite2D.animation_finished
	if is_instance_valid(enemy):
		enemy.undie = false

func _self_heal(heal):
	if hp + heal <= MAX_HP:
		hp += heal
	else:
		hp = MAX_HP
	_blink_sprite(Color(0.0, 0.711, 0.189, 1.0))
