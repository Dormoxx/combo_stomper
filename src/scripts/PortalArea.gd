extends Area2D
tool

export var next_scene: PackedScene

func _on_body_entered(body: Node) -> void:
	print("body entered")
	teleport()

func _get_configuration_warning() -> String:
	return "The next scene property can't be empty!" if not next_scene else ""

func teleport():
	$AnimationPlayer.play("fade_to_black")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(next_scene)

