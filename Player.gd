extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP

export var base_speed:= Vector2(750, 1250)
export var _gravity := 4000
export var dash_strength:= 2500

var can_dash: bool = true
var is_dashing: bool = false

var _velocity:= Vector2.ZERO

func _on_DashTimer_timeout() -> void:
	can_dash = true
	is_dashing = false


func _physics_process(delta: float) -> void:
	var jump_interrupt:= Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = calc_movement(_velocity, direction, base_speed, jump_interrupt, delta)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
				   -1.0 if Input.is_action_just_pressed("jump") else 1.0)

func calc_movement(velocity: Vector2, direction: Vector2, speed: Vector2, jump_canceled: bool, delta: float) -> Vector2:
	var new_vel = velocity
	
	new_vel.x = speed.x * direction.x
	
	if direction.y == -1.0: #jumping
		new_vel.y = speed.y * direction.y
	
	if !is_on_floor() and !is_dashing:
		new_vel.y += _gravity * delta
	
	if jump_canceled:
		new_vel.y = 0
	
	#fast fall
	if new_vel.y > 0.0:
		if Input.is_action_just_pressed("down"):
			new_vel.y += speed.y * direction.y
	if Input.is_action_just_pressed("dash") and can_dash:
		new_vel = Vector2(direction.x, 0).normalized() * dash_strength
		can_dash = false
		is_dashing = true
		$DashTimer.start()
		
	
	return new_vel


