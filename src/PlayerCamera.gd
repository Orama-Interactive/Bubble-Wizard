class_name PlayerCamera
extends Camera2D

@export var player: Player
@export var smoothing_enabled := true
@export_range(1, 10) var smoothing_distance := 2.0

var weight: float


func _ready() -> void:
	weight = (11.0 - smoothing_distance) / 100.0
	if not is_instance_valid(player):
		return
	global_position = player.global_position.round()


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		return
	var camera_position: Vector2
	if smoothing_enabled:
		camera_position = lerp(global_position, player.global_position, weight)
	else:
		camera_position = player.global_position
	global_position = camera_position
	#global_position = camera_position.round()
