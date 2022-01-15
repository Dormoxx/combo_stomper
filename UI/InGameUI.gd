extends Control


var paused:= false setget set_paused
onready var tree = get_tree()
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var combo_label: Label = $ComboLabel
onready var JumpUI: TextureRect = $CanJump
onready var DashUI: TextureRect = $CanDash
onready var PlayerNode: KinematicBody2D = get_node("../../Player")

func _ready() -> void:
	PlayerData.connect("combo_updated", self, "update_combo_label")
	PlayerNode.connect("jumped", self, "on_jumped")
	PlayerNode.connect("jump_refreshed", self, "on_jump_refresh")
	PlayerNode.connect("dashed", self, "on_dashed")
	PlayerNode.connect("dash_refreshed", self, "on_dash_refresh")
	


func set_paused(value: bool):
	paused = value
	tree.paused = value
	pause_overlay.visible = !pause_overlay.visible
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = !paused
		$CanJump.visible = !$CanJump.visible
		$CanDash.visible = !$CanDash.visible
		tree.set_input_as_handled()


func on_jumped():
	#JumpUI.modulate = Color(0, 0, 0, 1)
	JumpUI.visible = false

func on_jump_refresh():
	#JumpUI.modulate = Color(1, 1, 1, 1)
	JumpUI.visible = true

func on_dashed():
	#DashUI.modulate = Color(0, 0, 0, 1)
	DashUI.visible = false

func on_dash_refresh():
	#DashUI.modulate = Color(1, 1, 1, 1)
	DashUI.visible = true


func update_combo_label():
	if PlayerData.current_combo <= 1:
		combo_label.text = ""
		combo_label.visible = false
	else:
		combo_label.visible = true
		combo_label.text = "%s hit Combo!" % PlayerData.current_combo
