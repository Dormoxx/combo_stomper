extends Control

onready var scene_tree:= get_tree()
onready var pause_overlay: ColorRect = $PauseOverlay
onready var scoreLabel: Label = $ScoreLabel
onready var comboLabel: Label = $ComboLabel

var paused:= false setget set_paused

func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	PlayerData.connect("combo_updated", self, "update_combo_label")
	comboLabel.text = ""
	update_interface()

func _on_PlayerData_player_died():
	self.paused = true
	## the tutorial reuses the pause menu for the death menu,
	## but that seems sloppy to me
	## todo: create death ui menu

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = !paused
		scene_tree.set_input_as_handled()

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func update_interface():
	scoreLabel.text = "Score: %s" % PlayerData.score

func update_combo_label():
	if PlayerData.combo_count < 2:
		comboLabel.text = ""
	else:
		comboLabel.text = "%s Hit Combo!" % PlayerData.combo_count
	
