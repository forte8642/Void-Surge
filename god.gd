extends Node

@onready var Player = preload("res://Creatures/Player/Player.tscn")

var coins = 0

enum Items {
	SACRED_HAMMER,
	WALKING_BOOTS,
	LONG_HANDLE,
	SPEED_MANTLE
}

var items = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
