extends Control
class_name InputLabel

signal text_submitted(text)

@export var label: RichTextLabel
@export var caret: Control
@export var sparks: PackedScene
@export var color_correct: Color
@export var color_wrong: Color

var text: String = ""
var caret_pos: Vector2

const ALPHABET := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

func _ready():
	caret_pos = size / 2 - caret.size * 0.5
	caret.position = caret_pos
	set_input(false)
	
func set_input(do_enable: bool):
	set_process_input(do_enable)
	
func clear():
	_set_text("")

func show_answer(answer: String, correct: bool):
	_set_text("[u]%s[/u]" % answer.to_upper())
	if correct:
		modulate = color_correct
	else:
		modulate = color_wrong
	set_process_input(false)
	
func _process(delta):
	caret.position = lerp(caret.position, caret_pos, delta * 16)
	modulate = lerp(modulate, Color.WHITE, delta * 4)
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		var char = event.as_text_physical_keycode()
		if event.keycode == KEY_BACKSPACE:
			char = ""
			text = text.substr(0, len(text) - 1)
		elif event.keycode == KEY_SPACE:
			char = " "
		elif event.keycode == KEY_ENTER:
			char = ""
			text_submitted.emit(text)
			text = ""
		elif not (char in ALPHABET):
			char = ""
		text += char
		_set_text(text)
	
func _set_text(new: String):
	label.text = new
	label.custom_minimum_size = Vector2.ZERO
	label.size = Vector2.ZERO
	var text_size = label.size
	label.position = size / 2 - text_size / 2
	var new_caret_pos =  size / 2 + Vector2(text_size.x * 0.5 + 6.0, 0.0) - caret.size * 0.5
	if new_caret_pos.x > caret_pos.x:
		var part = sparks.instantiate()
		part.position = new_caret_pos
		add_child(part)
		part.position = caret_pos + caret.size * 0.5 + Vector2(10.0, 0.0)
	else:
		var part = sparks.instantiate()
		part.position = new_caret_pos
		part.scale.x = -1
		add_child(part)
		part.position = caret_pos + caret.size * 0.5 + Vector2(-2.0, 0.0)
	caret_pos = new_caret_pos
		
