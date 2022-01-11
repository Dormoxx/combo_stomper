extends "res://src/scripts/Actor.gd"

#todo : VisibilityEnabler2D: https://www.youtube.com/watch?v=Mc13Z2gboEk&t=4768s

onready var stompDetector: Area2D = $StompDetector

export var scoreValue:= 100
func _ready() -> void:
	_speed.x = 150
	_velocity.x = -_speed.x

func _on_StompDetectorArea_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y > stompDetector.global_position.y:
		return
	die()


func _physics_process(delta: float) -> void:
	#_velocity = Vector2.ZERO
	if !is_on_floor(): #apply gravity only when in the air
		_velocity.y += _gravity * delta
	if is_on_wall():
		_velocity.x *= -1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func die():
	queue_free()
	PlayerData.score += scoreValue
	PlayerData.increase_combo()

