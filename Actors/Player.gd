extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP

export var base_speed:= Vector2(750, 1250)
export var _gravity := 4000

export var can_jump: bool = true
export var is_jumping: bool = false
var coyote_time: bool = false
var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: Vector2
var dash_speed:= base_speed * 1.5

var _velocity:= Vector2.ZERO


func _physics_process(delta: float) -> void:
	var jump_interrupt:= Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	
	_velocity = calc_movement(_velocity, direction, base_speed, jump_interrupt, delta)
	var was_on_floor = is_on_floor()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	if !is_on_floor() and was_on_floor:
		$CoyoteTimer.start()
		coyote_time = true
	
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()

func get_direction() -> Vector2:
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
				   -1.0 if Input.is_action_just_pressed("jump") else 1.0)

func calc_movement(velocity: Vector2, direction: Vector2, speed: Vector2, jump_canceled: bool, delta: float) -> Vector2:
	var new_vel = velocity
	
	if is_on_floor():
		is_jumping = false
		can_jump = true
		can_dash = true
	
	if !is_dashing:
		new_vel.x = speed.x * direction.x
	
	if !is_on_floor() and !is_dashing:
		new_vel.y += _gravity * delta
	
	if direction.y == -1.0: #jumping
		if can_jump or coyote_time:
			#$CoyoteTimer.stop()
			new_vel.y = speed.y * direction.y
			can_jump = false
			is_jumping = true

	if jump_canceled:
		new_vel.y = 0
	
	if new_vel.y > 0.0: #fast fall
		if Input.is_action_just_pressed("down"):
			new_vel.y += speed.y * direction.y
	
	new_vel = dash(new_vel)
	return new_vel

func calc_stomp_velocity(velocity: Vector2, impulse: float):
	var new_vel = velocity
	new_vel.y = -impulse
	is_jumping = true
	can_jump = false
	return new_vel

func dash(velocity: Vector2):
	if !is_dashing:
		dash_direction = Vector2.ZERO
		if Input.is_action_just_pressed("dash") and can_dash:
			if Input.is_action_pressed("left"):
				dash_direction.x = -1
			if Input.is_action_pressed("right"):
				dash_direction.x = 1
			if Input.is_action_pressed("down"):
				dash_direction.y = 1
			if Input.is_action_pressed("up"):
				dash_direction.y = -0.5
			if dash_direction != Vector2.ZERO:
				velocity = dash_direction * dash_speed
				can_dash = false
				is_dashing = true
				$DashTimer.start()
	return velocity

func die():
	get_tree().reload_current_scene()

func _on_DashTimer_timeout() -> void:
	#can_dash = true
	is_dashing = false

func _on_CoyoteTimer_timeout() -> void:
	coyote_time = false

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	die()

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.position.y < position.y:
		_velocity = calc_stomp_velocity(_velocity, dash_speed.y)
		can_dash = true
		can_jump = true
