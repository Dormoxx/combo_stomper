extends "res://src/scripts/Actor.gd"

#todo : VisibilityEnabler2D: https://www.youtube.com/watch?v=Mc13Z2gboEk&t=4768s

onready var stompArea = $StompArea
onready var stompColl = $StompArea/StompCollider
export var scoreValue:= 100
export var stopit:= false
func _ready() -> void:
	_velocity.x = -_speed.x

func _on_StompArea_body_entered(body: Node) -> void:
	if body.global_position.y > stompArea.global_position.y:
		return
	#die()

func _physics_process(delta: float) -> void:
	if !is_on_floor(): #apply gravity only when in the air
		_velocity.y += _gravity * delta
	if is_on_wall() and !stopit:
		_velocity.x *= -1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func die():
	queue_free()
	PlayerData.score += scoreValue
