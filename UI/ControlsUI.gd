extends Control



func _on_UpButton_button_up() -> void:
	$RebindOverlay.visible = true
	
	erase_action_events("up")
	
	var new_event = InputEventKey.new()
	InputMap.action_add_event("up", new_event)
	
	$RebindOverlay.visible = false
	

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)
