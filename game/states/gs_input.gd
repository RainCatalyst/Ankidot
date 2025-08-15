extends State

func enter(from_state: State):
	object.input_label.set_input(true)
	object.input_label.text_submitted.connect(_on_submitted)

func exit(to_state: State):
	object.input_label.set_input(false)
	object.input_label.text_submitted.disconnect(_on_submitted)

func process(delta):
	pass

func _on_submitted(text):
	if AnkiAPI.is_word_correct(text):
		object.guess_correct()
	else:
		object.guess_wrong()
