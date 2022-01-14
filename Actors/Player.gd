extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var dash_ghost = preload("res://Effects/DashGhost.tscn")

onready var animPlayer: AnimationPlayer = $AnimationPlayer
onready var coyoteTimer: Timer = $CoyoteTimer
onready var dashTimer: Timer = $DashTimer
onready var ghostTimer: Timer = $DashTimer/GhostTimer
onready var sprite: Sprite = $Sprite
onready var comboAudio: AudioStreamPlayer = $ComboAudio

export var base_speed:= Vector2(750, 1250)
export var _gravity := 4000

var can_jump:    bool = true
var can_dash:    bool = true
var is_midair:   bool = false
var is_dashing:  bool = false
var coyote_time: bool = false
var dash_speed:= base_speed * 1.5
export var dash_time := 0.25

var combo_pitch: float = 1.0

var _velocity:= Vector2.ZERO

signal jumped
signal jump_refreshed
signal dashed
signal dash_refreshed


func _ready() -> void:
	PlayerData.connect("combo_increased", self, "combo_bongs")
	PlayerData.current_combo = 0

func _physics_process(delta: float) -> void:
	var jump_interrupt:= Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	
	_velocity = calc_movement(_velocity, direction, base_speed, jump_interrupt, delta)
	var was_on_floor = is_on_floor()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	if !is_on_floor() and was_on_floor:
		coyoteTimer.start()
		coyote_time = true
	
	verify_combo()
	reset()

func get_direction() -> Vector2:
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
				   -1.0 if Input.is_action_just_pressed("jump") else 1.0)

func calc_movement(velocity: Vector2, direction: Vector2, speed: Vector2, jump_canceled: bool, delta: float) -> Vector2:
	var new_vel = velocity
	
	if is_on_floor():
		can_jump = true
		can_dash = true
		emit_signal("dash_refreshed")
		emit_signal("jump_refreshed")
	
	if !is_dashing:
		new_vel.x = speed.x * direction.x
	
	if !is_on_floor():
		is_midair = true
		if !is_dashing:
			new_vel.y += _gravity * delta
		
	
	if direction.y == -1.0: #jumping
		if can_jump or coyote_time:
			#$CoyoteTimer.stop()
			new_vel.y = speed.y * direction.y
			can_jump = false
			is_midair = true
			animPlayer.play("Jump")
			emit_signal("jumped")

	if jump_canceled:
		new_vel.y = 0
	
	if new_vel.y > 0.0: #fast fall
		if Input.is_action_just_pressed("down"):
			new_vel.y += speed.y * direction.y
	
	new_vel = dash(new_vel)
	
	if is_on_floor() and new_vel.y == 0:
		is_midair = false
	return new_vel

func calc_stomp_velocity(velocity: Vector2, impulse: float):
	var new_vel = velocity
	new_vel.y = -impulse
	can_jump = false
	is_midair = true
	return new_vel

func dash(velocity: Vector2):
	if !is_dashing:
		var dash_direction = Vector2.ZERO
		if Input.is_action_just_pressed("dash") and can_dash:
			if Input.is_action_pressed("left"):
				dash_direction.x = -1
				animPlayer.play("HDash")
			if Input.is_action_pressed("right"):
				dash_direction.x = 1
				animPlayer.play("HDash")
			if Input.is_action_pressed("down"):
				dash_direction.y = 1
				animPlayer.play("VDash")
			if Input.is_action_pressed("up"):
				dash_direction.y = -0.5
				animPlayer.play("VDash")
			if dash_direction != Vector2.ZERO:
				velocity = dash_direction * dash_speed
				can_dash = false
				is_dashing = true
				emit_signal("dashed")
				dashTimer.start(dash_time)
				ghostTimer.start()
				instance_ghost()
				sprite.material.set_shader_param("mix_weight", 0.35)
				sprite.material.set_shader_param("whiten", true)
	return velocity

func instance_ghost():
	var g: Sprite = dash_ghost.instance()
	get_parent().get_parent().add_child(g)
	
	g.global_position = global_position
	g.texture = sprite.texture
	#g.modulate = $Sprite.modulate
	

func die():
	get_tree().reload_current_scene()

func verify_combo():
	if !is_midair:
		PlayerData.current_combo = 0

func reset():
	if Input.is_action_just_pressed("r"):
		PlayerData.current_combo = 0
		get_tree().reload_current_scene()

func combo_bongs():
	if PlayerData.current_combo <= 1:
		combo_pitch = 1.0
	if PlayerData.current_combo > 1:
		combo_pitch = (1 + (((PlayerData.current_combo) / 10.0) - 0.1))
	comboAudio.pitch_scale = combo_pitch
	comboAudio.play()

func _on_DashTimer_timeout() -> void:
	#can_dash = true
	is_dashing = false
	ghostTimer.stop()
	sprite.material.set_shader_param("whiten", false)

func _on_CoyoteTimer_timeout() -> void:
	coyote_time = false

func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	die()

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.position.y < position.y:
		_velocity = calc_stomp_velocity(_velocity, dash_speed.y)
		can_dash = true
		emit_signal("dash_refreshed")
		can_jump = true
		emit_signal("jump_refreshed")
		is_midair = true
		PlayerData.increase_combo()

func _on_GhostTimer_timeout() -> void:
	instance_ghost()
