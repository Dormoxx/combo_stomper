extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP

export var base_speed:= Vector2(750, 1250)
export var _gravity := 4000

var can_jump: bool = true
var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: Vector2
var dash_speed:= Vector2(4500, base_speed.y)

var _velocity:= Vector2.ZERO

func _on_DashTimer_timeout() -> void:
	can_dash = true
	is_dashing = false
	$AnimationPlayer.play("default")

func _ready() -> void:
	$AnimationPlayer.play("default")

func _physics_process(delta: float) -> void:
	var jump_interrupt:= Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	can_jump = is_on_floor()
	
	_velocity = calc_movement(_velocity, direction, base_speed, jump_interrupt, delta)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
				   -1.0 if Input.is_action_just_pressed("jump") else 1.0)

func calc_movement(velocity: Vector2, direction: Vector2, speed: Vector2, jump_canceled: bool, delta: float) -> Vector2:
	var new_vel = velocity
	
	new_vel.x = speed.x * direction.x
	
	if !is_on_floor() and !is_dashing:
		new_vel.y += _gravity * delta
	
	if direction.y == -1.0 and can_jump: #jumping
		new_vel.y = speed.y * direction.y
		can_jump = false
	
	
	if jump_canceled:
		new_vel.y = 0
	
	
	if new_vel.y > 0.0: #fast fall
		if Input.is_action_just_pressed("down"):
			new_vel.y += speed.y * direction.y
	
	new_vel = dash(new_vel)
	
	
	return new_vel

func dash(velocity: Vector2):
	dash_direction = Vector2.ZERO
	if !is_dashing:
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
				$AnimationPlayer.play("dash")
				$DashTimer.start()
	return velocity
