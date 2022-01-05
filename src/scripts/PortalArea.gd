extends Area2D
tool

export var next_scene: PackedScene
onready var animPlayer:= $AnimationPlayer

func _on_body_entered(body: Node) -> void:
	teleport()

func _get_configuration_warning() -> String:
	return "The next scene property can't be empty!" if not next_scene else ""

func teleport():
	animPlayer.play("fade_to_black")
	yield(animPlayer, "animation_finished")
	get_tree().change_scene_to(next_scene)

