extends CharacterBody2D

@export var horizontal_speed := 300.0
@export_category("Jumping and Gravity")
@export var jump_velocity := -100.0
@export var coyote_seconds := 0.2
@export var jump_buffer := 0.2
## The strength at which your character will be pulled to the ground.
@export_range(0, 20) var gravity_scale := 2.0
## Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var descending_gravity_factor := 1.1
@export var terminal_velocity := 1200.0
@export var fall_damage_velocity := 700.0
@export_category("Bubble form")
@export var bubble_speed := 120.0
@export var bubble_vertical_speed := 1.0
@export var bubble_decelerate := 10.0
@export var bubble_gravity_scale := 0.2
@export var bubble_duration := 2.0
@export var bubble_charge_time := 0.6
var can_jump := false
var jump_pressed := false
var bubble_form := false:
	set(value):
		bubble_form = value
		if bubble_form:
			velocity.y = 0
			can_jump = true
			bubble_timer.start()
var last_vertical_velocity := 0.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bubble_timer: Timer = $BubbleTimer
@onready var charge_bubble_timer: Timer = $ChargeBubbleTimer


func _ready() -> void:
	animated_sprite_2d.play(&"idle")
	bubble_timer.wait_time = bubble_duration
	charge_bubble_timer.wait_time = bubble_charge_time


func _physics_process(delta: float) -> void:
	if bubble_form:
		_bubble_movement(delta)
	else:
		_normal_movement(delta)


func _normal_movement(delta: float) -> void:
	_charge_bubble_form()
	if is_on_floor():
		can_jump = true
	else:
		if can_jump:
			_coyote_time()
		var gravity := get_gravity() * delta * gravity_scale
		if velocity.y > 0:
			gravity *= descending_gravity_factor
		velocity += gravity

	_handle_jump()

	var direction := _handle_horizontal_movement(horizontal_speed, horizontal_speed)
	if not is_zero_approx(direction):
		if not charge_bubble_timer.is_stopped():
			charge_bubble_timer.stop()

	velocity.y = clampf(velocity.y, -terminal_velocity, terminal_velocity)
	last_vertical_velocity = velocity.y
	move_and_slide()


func _bubble_movement(delta: float) -> void:
	if _handle_jump():
		bubble_form = false
		return
	_handle_horizontal_movement(bubble_speed, bubble_decelerate)
	var direction_vert := Input.get_axis(&"up", &"down")
	var gravity := get_gravity() * delta * bubble_gravity_scale
	if direction_vert:
		gravity *= direction_vert * bubble_vertical_speed
	velocity += gravity
	velocity.y = clampf(velocity.y, -terminal_velocity, terminal_velocity)
	move_and_slide()


func _handle_horizontal_movement(speed: float, deceleration: float) -> float:
	var direction := Input.get_axis(&"left", &"right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
	if direction > 0:
		animated_sprite_2d.scale.x = 1
		animated_sprite_2d.play(&"walk")
	elif direction < 0:
		animated_sprite_2d.scale.x = -1
		animated_sprite_2d.play(&"walk")
	else:
		animated_sprite_2d.play(&"idle")
	return direction


func _handle_jump() -> bool:
	if Input.is_action_pressed(&"jump"):
		jump_pressed = true
		_jump_buffer()
	if velocity.y < 0 and Input.is_action_just_released(&"jump"):
		jump_pressed = false
	if jump_pressed and can_jump:
		velocity.y = jump_velocity
		return true
	return false


func _coyote_time() -> void:
	await get_tree().create_timer(coyote_seconds).timeout
	can_jump = false


func _jump_buffer() -> void:
	await get_tree().create_timer(jump_buffer).timeout
	jump_pressed = false


func _handle_death() -> void:
	print("YOU DIED")


func _charge_bubble_form() -> void:
	if Input.is_action_just_pressed("charge_bubble"):
		charge_bubble_timer.start()
	if Input.is_action_just_released("charge_bubble"):
		if not charge_bubble_timer.is_stopped():
			charge_bubble_timer.stop()


func _on_bubble_timer_timeout() -> void:
	bubble_form = false


func _on_charge_bubble_timer_timeout() -> void:
	bubble_form = true
	position.y -= 32


func _on_bubble_area_2d_body_entered(_body: Node2D) -> void:
	if not bubble_form and last_vertical_velocity > fall_damage_velocity:
		_handle_death()
	bubble_form = false


func _on_spike_area_2d_body_entered(_body: Node2D) -> void:
	_handle_death()


func _on_powerup_area_2d_area_shape_entered(
	_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int
) -> void:
	if "ExtendBubbleDurationItem" in area.name and bubble_form:
		bubble_timer.start()
		area.queue_free()
