extends Area2D
tool

export var next_scene: PackedScene

func teleport():
	$AnimationPlayer.play("fade_to_black")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(next_scene)


func _get_configuration_warning() -> String:
	return "Next Scene Property cannot be empty!" if !next_scene else ""


func _on_body_entered(body: Node) -> void:
	teleport()
