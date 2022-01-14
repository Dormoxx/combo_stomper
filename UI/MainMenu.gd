extends Control

func _ready() -> void:
	get_tree().paused = false

func _on_PlayButton_button_up() -> void:
	get_tree().change_scene("res://LevelTemplate.tscn")
