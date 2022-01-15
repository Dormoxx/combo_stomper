extends Node

signal combo_updated
signal combo_increased

var current_combo: int = 0 setget set_current_combo, get_current_combo

func increase_combo():
	current_combo += 1
	emit_signal("combo_increased")
	emit_signal("combo_updated")

func set_current_combo(value: int):
	current_combo = value
	emit_signal("combo_updated")

func get_current_combo() -> int:
	return current_combo
