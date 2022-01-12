extends KinematicBody2D

export var _speed:= Vector2(250, 750)
export var _gravity := 4000
var _velocity:= Vector2.ZERO

func _ready() -> void:
	#_speed.x = 150
	_velocity.x = -_speed.x

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		_velocity.y += _gravity * delta
	if is_on_wall():
		_velocity *= -1
	_velocity.y = move_and_slide(_velocity, Vector2.UP).y
