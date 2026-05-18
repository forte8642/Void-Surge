extends Node2D

var player_in_zone = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if self.get_parent().calmly == false:
		$Icon6.visible = true
		$Icon5.visible = true
		$Area2D.monitorable = false
	if self.get_parent().calmly == true:
		$Icon6.visible = false
		$Icon5.visible = false
		$Area2D.monitorable = true
	
	if player_in_zone == true and self.get_parent().calmly == true:
		if Input.is_action_just_pressed("ui_open"):
			get_parent().shop = true
			$"../CanvasLayer/ShopGUI".visible = true
			print("signal connected")
	if get_parent().shop == true:
		if Input.is_action_just_pressed("ui_cancel"):
			get_parent().shop = false
			$"../CanvasLayer/ShopGUI".visible = false


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		player_in_zone = true
		print("body entered")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_zone = false
		print("body exited")
