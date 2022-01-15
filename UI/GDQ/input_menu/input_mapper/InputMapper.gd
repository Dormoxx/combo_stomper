extends Node

signal profile_changed(new_profile, is_customizable)

var current_profile_id = 2
var profiles = {
	0: 'profile_normal',
	1: 'profile_alternate',
	2: 'profile_custom',
}
var profile_normal = {
	'up': KEY_UP,
	'down': KEY_DOWN,
	'left': KEY_LEFT,
	'right': KEY_RIGHT,
	'dash': KEY_X,
	'jump': KEY_Z
}
var profile_alternate = {
	'up': KEY_W,
	'down': KEY_S,
	'left': KEY_A,
	'right': KEY_D,
	'dash': KEY_K,
	'jump': KEY_L
}
var profile_custom = profile_normal

func change_profile(id):
	current_profile_id = id
	var profile = get(profiles[id])
	var is_customizable = true
	
	for action_name in profile.keys():
		change_action_key(action_name, profile[action_name])
	emit_signal('profile_changed', profile, is_customizable)
	return profile

func change_action_key(action_name, key_scancode):
	erase_action_events(action_name)

	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)
	get_selected_profile()[action_name] = key_scancode

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

func get_selected_profile():
	return get(profiles[current_profile_id])

func _on_ProfilesMenu_item_selected(ID):
	change_profile(ID)
