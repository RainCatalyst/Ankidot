extends Control

@export var line_edit: LineEdit

func _ready():
	line_edit.edit.call_deferred()


func _on_line_edit_text_submitted(new_text):
	Global.game.test()
	line_edit.text = ""
	line_edit.edit.call_deferred()


func _on_line_edit_text_changed(new_text):
	line_edit.text = line_edit.text.to_upper()
	line_edit.caret_column = len(line_edit.text)
	
