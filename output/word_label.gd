extends Control
class_name WordLabel

@export var label: RichTextLabel
@export var background: Control

var target_size: Vector2
var target_pos: Vector2
var t: float = 0.0

var MIN_SIZE_X = 200
var PAD = Vector2(80, 20)

func _ready():
	target_size = background.size
	target_pos = background.position

func set_text(text: String):
	label.text = "[wave]%s" % text
	label.custom_minimum_size = Vector2.ZERO
	label.size = Vector2.ZERO
	var text_size = label.size
	target_size = text_size
	label.position = size / 2 - target_size / 2
	target_size.x = max(target_size.x, MIN_SIZE_X) + PAD.x
	target_size.y += PAD.y
	target_pos = size / 2 - target_size / 2
	label.modulate.a = 0.0
	t = 0.0
	
func hide_text():
	label.text = ""
	target_pos = size / 2
	t = 0.5
	target_size.x = 0
	target_size.y = 0

func _process(delta):
	t += delta
	if t > 0.2:
		label.modulate.a = lerp(label.modulate.a, 1.0, 12 * delta)
	background.size = lerp(background.size, target_size, 12 * delta)
	if (background.size - target_size).length_squared() < 16:
		background.size = target_size
	background.position = lerp(background.position, target_pos, 12 * delta)
	if (background.position - target_pos).length_squared() < 16:
		background.position = target_pos
	
