extends CanvasLayer

var assortment = [
God.Items.SACRED_HAMMER,
God.Items.WALKING_BOOTS,
God.Items.SPEED_MANTLE,
God.Items.LONG_HANDLE
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_sacred_hammer_pressed():
	if God.coins >= 100:
		if God.Items.SACRED_HAMMER in assortment:
			God.items.append(God.Items.SACRED_HAMMER)
			assortment.erase(God.Items.SACRED_HAMMER)
			$VBoxContainer/Sacred_Hammer/Icon2.visible = true
			$VBoxContainer/Sacred_Hammer/Icon.visible = true
			_apply_buffs()
			God.coins -= 100

func _on_walking_boots_pressed():
	if God.coins >= 100:
		if God.Items.WALKING_BOOTS in assortment:
			God.items.append(God.Items.WALKING_BOOTS)
			assortment.erase(God.Items.WALKING_BOOTS)
			$VBoxContainer/Walking_boots/Icon2.visible = true
			$VBoxContainer/Walking_boots/Icon.visible = true
			_apply_buffs()
			God.coins -= 100

func _on_speed_mantle_pressed() -> void:
	if God.coins >= 150:
		if God.Items.SPEED_MANTLE in assortment:
			God.items.append(God.Items.SPEED_MANTLE)
			assortment.erase(God.Items.SPEED_MANTLE)
			$"VBoxContainer/Speed​_Mantle/Icon2".visible = true
			$"VBoxContainer/Speed​_Mantle/Icon".visible = true
			_apply_buffs()
			God.coins -= 150
#
func _on_long_handle_pressed() -> void:
	if God.coins >= 300:
		if God.Items.LONG_HANDLE in assortment:
			God.items.append(God.Items.LONG_HANDLE)
			assortment.erase(God.Items.LONG_HANDLE)
			$"VBoxContainer/Long_handle/Icon2".visible = true
			$"VBoxContainer/Long_handle/Icon".visible = true
			_apply_buffs()
			God.coins -= 300

func _apply_buffs():
	# Находим игрока и обновляем его баффы
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.player_damage = 1  # Сброс к базовому значению
		player.speed_buff = 0
		player.attack_buff = false
		player.charge_buff = 0

		for item in God.items:
			match item:
				God.Items.SACRED_HAMMER:
					player.player_damage = 3
				God.Items.WALKING_BOOTS:
					player.speed_buff = 100
				God.Items.LONG_HANDLE:
					player.attack_buff = true
				God.Items.SPEED_MANTLE:
					player.charge_buff = 33
