extends Actor

export var stomp_impulse:= 1250
var stomp_increment:= 250
var combo_pitch
var scaled_speed: Vector2 = _speed
export(Vector2) var speed_scale = Vector2(25, 25)
onready var enemyDetector: Area2D = $EnemyDetector

var is_midair: bool

func _ready() -> void:
	PlayerData.connect("combo_increased", self, "peggle_bongs")
	PlayerData.combo_count = 0
	#Engine.time_scale = 0.1

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calc_stomp_velocity(_velocity, stomp_impulse)
	if _velocity.y != 0:
		is_midair = true

func _on_EnemyDetector_body_entered(body: Node) -> void:
	die()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("reset"):
		get_tree().reload_current_scene() #hacky
	
	var jump_interrupt:= Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction:= get_direction()
	_velocity = calc_movement(_velocity, direction, _speed, jump_interrupt, delta)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	verify_combo()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") else 1.0)

func calc_movement(velocity: Vector2, direction: Vector2, speed: Vector2, jump_canceled: bool, delta: float) -> Vector2:
	var new_velocity = velocity
	if PlayerData.combo_count <= 1:
		new_velocity.x = speed.x * direction.x
	else:
		new_velocity.x = scaled_speed.x * direction.x
	
	#override jump behavior (-1.0 from get_input())
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
		is_midair = true
	
	if !is_on_floor(): #only apply gravity while not on floor
		new_velocity.y += _gravity * delta

	
	if jump_canceled: #player stops holding jump
		new_velocity.y = 0.0
	
	if new_velocity.y >= 0.0: #fast fall
		if Input.is_action_just_pressed("down"):
			new_velocity.y += speed.y * direction.y
	if is_on_floor() and new_velocity.y == 0:
		is_midair = false
	return new_velocity

func calc_stomp_velocity(velocity: Vector2, impulse: float) -> Vector2:
	var new_vel:= velocity

	if PlayerData.combo_count == 0 or 1:
		new_vel.y = -(impulse)
	if PlayerData.combo_count >= 2:
		new_vel.y = -(impulse + (PlayerData.combo_count * stomp_increment))
		scaled_speed.x += (speed_scale.x * PlayerData.combo_count)
		scaled_speed.y += (speed_scale.y * PlayerData.combo_count)
	if new_vel.y != 0:
		is_midair = true
	return new_vel

func verify_combo():
	if !is_midair:
		PlayerData.combo_count = 0

func peggle_bongs():
	if PlayerData.combo_count <= 1:
		combo_pitch = 1.0
	if PlayerData.combo_count > 1:
		combo_pitch = (1 + (((PlayerData.combo_count) / 10.0) - 0.1))
	$AudioCombo.pitch_scale = combo_pitch
	$AudioCombo.play()
	

func die():
	PlayerData.deaths += 1
	queue_free()
	#get_tree().reload_current_scene()
	
	






