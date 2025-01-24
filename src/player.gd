extends CharacterBody2D

@export var speed := 300.0
@export_category("Jumping and Gravity")
@export var jump_velocity := -300.0
@export var coyote_seconds := 0.2
@export var jump_buffer := 0.2
## The strength at which your character will be pulled to the ground.
@export_range(0, 20) var gravity_scale := 2.0
## Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var descending_gravity_factor := 1.1
@export var terminal_velocity := 400.0
@export_category("Bubble form")
@export var bubble_duration := 2.0
@export var bubble_speed := 120.0
@export var bubble_vertical_speed := 1.0
@export var bubble_decelerate := 10.0
@export var bubble_gravity_scale := 0.4
var can_jump := false
var jump_pressed := false
var bubble_form := false


func _physics_process(delta: float) -> void:
	if bubble_form:
		_bubble_movement(delta)
	else:
		_normal_movement(delta)


func _bubble_movement(delta: float) -> void:
	#var direction := Input.get_vector(&"left", &"right", &"up", &"down")
	var direction_horiz :=  Input.get_axis(&"left", &"right")
	if direction_horiz:
		velocity.x = direction_horiz * bubble_speed
	else:
		velocity.x = move_toward(velocity.x, 0, bubble_decelerate)
		#velocity.y = move_toward(velocity.y, 0, bubble_decelerate)

	var direction_vert := Input.get_axis(&"up", &"down")
	#if direction_vert:
		#velocity.y = direction_vert * bubble_speed
	#else:
		#velocity.y = move_toward(velocity.y, 0, bubble_decelerate)
	var gravity := get_gravity() * delta * bubble_gravity_scale
	if direction_vert:
		#gravity = get_gravity() * delta * bubble_gravity_scale * direction_vert * ver
		gravity *= direction_vert * bubble_vertical_speed
	velocity += gravity
	velocity.y = clampf(velocity.y, -terminal_velocity, terminal_velocity)
	#print(direction_horiz, " ", velocity)
	#print(gravity, " ", velocity)
	move_and_slide()


func _normal_movement(delta: float) -> void:
	# Add the gravity.
	if is_on_floor():
		can_jump = true
	else:
		if can_jump:
			_coyote_time()
		var gravity := get_gravity() * delta * gravity_scale
		if velocity.y > 0:
			gravity *= descending_gravity_factor
		velocity += gravity

	# Handle jump.
	if Input.is_action_pressed(&"up"):
		jump_pressed = true
		_jump_buffer()
	if velocity.y < 0 and Input.is_action_just_released(&"up"):
		jump_pressed = false
	if jump_pressed and can_jump:
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(&"left", &"right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	velocity.y = clampf(velocity.y, -terminal_velocity, terminal_velocity)
	move_and_slide()


func _coyote_time() -> void:
	await get_tree().create_timer(coyote_seconds).timeout
	can_jump = false


func _jump_buffer() -> void:
	await get_tree().create_timer(jump_buffer).timeout
	jump_pressed = false
