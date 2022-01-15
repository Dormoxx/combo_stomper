extends Node2D

func _ready() -> void:
	var x: Array = InputMap.get_action_list("jump")
	for i in x:
		print(OS.get_scancode_string(i.physical_scancode))

