extends Sprite

var effect_duration: float = 0.5

func _ready() -> void:
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, effect_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "scale:x", 1.0, 0.70, effect_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "scale:y", 1.0, 0.70, effect_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()


func _on_Tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
