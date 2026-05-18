extends RigidBody2D

var value = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Icon.rotation += 15
	$Icon.modulate = Color(0.753, 0.8, 0.0, 1.0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		God.coins += value
		queue_free()
