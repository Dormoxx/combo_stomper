extends Control

onready var statsLabel: Label = $GameOverStatsLabel

func _ready() -> void:
	statsLabel.text = statsLabel.text % [PlayerData.score, PlayerData.deaths, PlayerData.highest_combo]
	$AudioStreamPlayer.play()
