extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const HEAL = 3

func _ready() -> void:
	$Icon.modulate = Color(0.441, 1.0, 0.484, 1.0)

func _physics_process(_delta: float) -> void:
	$Icon.rotation += 15
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if is_instance_valid(body):
			body._self_heal(HEAL)
			queue_free()
