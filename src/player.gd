class_name Player
extends CharacterBody2D

@export var horizontal_speed := 150.0
@export_category("Jumping and Gravity")
@export var jump_velocity := -100.0
@export var coyote_seconds := 0.2
@export var jump_buffer := 0.05
## The strength at which your character will be pulled to the ground.
@export_range(0, 20) var gravity_scale := 1.4
## Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var descending_gravity_factor := 1.1
@export var terminal_velocity := 1200.0
@export var fall_damage_velocity := 500.0
@export_category("Bubble form")
@export var bubble_speed := 120.0
@export var bubble_vertical_speed := 1.0
@export var bubble_decelerate := 10.0
@export var bubble_gravity_scale := 0.2
@export var bubble_duration := 2.0
@export var bubble_charge_time := 0.6
var can_move := true
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
var just_jumped_off_bubble := false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bubble_timer: Timer = $BubbleTimer
@onready var charge_bubble_timer: Timer = $ChargeBubbleTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer


func _ready() -> void:
	animated_sprite_2d.play(&"idle")
	bubble_timer.wait_time = bubble_duration
	charge_bubble_timer.wait_time = bubble_charge_time
	coyote_timer.wait_time = coyote_seconds
	jump_buffer_timer.wait_time = jump_buffer
	var camera := PlayerCamera.new()
	camera.player = self
	camera.limit_left = 0
	get_parent().add_child.call_deferred(camera)


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
		if can_jump and coyote_timer.is_stopped():
			coyote_timer.start()
		var gravity := get_gravity() * delta * gravity_scale
		if velocity.y > 0:
			gravity *= descending_gravity_factor
		velocity += gravity

	_handle_jump()
	# Jump animations
	if not is_zero_approx(velocity.y):
		if velocity.y < 0 and velocity.y > -20:
			animated_sprite_2d.play(&"jump_highest")
		if velocity.y > 0:
			animated_sprite_2d.play(&"fall")


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
	if not can_move:
		direction_vert = 0.0
	var gravity := get_gravity() * delta * bubble_gravity_scale
	if direction_vert:
		gravity *= direction_vert * bubble_vertical_speed
	velocity += gravity
	velocity.y = clampf(velocity.y, -terminal_velocity, terminal_velocity)
	move_and_slide()


func _handle_horizontal_movement(speed: float, deceleration: float) -> float:
	var direction := Input.get_axis(&"left", &"right")
	if not can_move:
		direction = 0.0
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
	if direction > 0:
		animated_sprite_2d.scale.x = 1
		if is_zero_approx(velocity.y):
			animated_sprite_2d.play(&"walk")
	elif direction < 0:
		animated_sprite_2d.scale.x = -1
		if is_zero_approx(velocity.y):
			animated_sprite_2d.play(&"walk")
	else:
		if is_zero_approx(velocity.y):
			animated_sprite_2d.play(&"idle")
	return direction


func _handle_jump() -> bool:
	if Input.is_action_pressed(&"jump") and jump_buffer_timer.is_stopped() and can_move:
		jump_pressed = true
		jump_buffer_timer.start()
	if Input.is_action_just_released(&"jump"):
		just_jumped_off_bubble = false
		if velocity.y < 0:
			jump_pressed = false
			can_jump = false
			coyote_timer.stop()
			jump_buffer_timer.stop()
	if jump_pressed and can_jump:  # Jump
		var final_jump_velocity := jump_velocity
		if bubble_form:
			just_jumped_off_bubble = true
		if just_jumped_off_bubble:
			final_jump_velocity *= 2.0
		velocity.y = final_jump_velocity
		animated_sprite_2d.play(&"jump_up")
		return true
	return false


func _handle_death() -> void:
	GameManager.restart_level()


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
	bubble_form = false
	_handle_death()


func _on_powerup_area_2d_area_shape_entered(
	_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int
) -> void:
	if "ExtendBubbleDurationItem" in area.name and bubble_form:
		bubble_timer.start()
		area.queue_free()


func _on_coyote_timer_timeout() -> void:
	can_jump = false


func _on_jump_buffer_timer_timeout() -> void:
	jump_pressed = false
