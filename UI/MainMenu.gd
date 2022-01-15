extends Control

func _ready() -> void:
	get_tree().paused = false

func _on_PlayButton_button_up() -> void:
	get_tree().change_scene("res://Levels/World1/1-1.tscn")


func _on_ControlsButton_button_up() -> void:
	get_tree().change_scene("res://UI/GDQ/input_menu/InputMenu.tscn")
