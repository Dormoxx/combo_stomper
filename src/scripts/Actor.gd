extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL:= Vector2.UP

export var _speed:= Vector2(300, 1000)
var _gravity:= 4000
var _velocity:= Vector2.ZERO

func _physics_process(delta):
	pass
	#_velocity.y += _gravity*delta
