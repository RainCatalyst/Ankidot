extends Control
class_name MistakeBox

var tween: Tween
var target_pos: Vector2

func _ready():
	target_pos = position

func _process(delta):
	position = lerp(position, target_pos, delta * 12)
	
func set_target_pos(pos: Vector2):
	target_pos = pos

func toggle_on(delay: float = 0.0):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_callback(func(): scale = Vector2.ONE * 0.8).set_delay(delay)
	tween.tween_property(self, "scale", Vector2.ONE, 0.225).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK).set_delay(delay)
	tween.parallel().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3).set_delay(delay)

func toggle_off():
	if tween:
		tween.kill()
	scale = Vector2.ONE * 1.25
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.225).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(self, "modulate", Color(0.85, 0.85, 0.85, 1.0), 0.3)
