extends State

func post_setup():
	AnkiAPI.word_data_received.connect(_on_word_received)

func enter(from_state: State):
	object.background.reset_bg()
	AnkiAPI.request_word_data()

func exit(to_state: State):
	pass

func process(delta):
	pass

func _on_word_received(success: bool):
	if success:
		object.set_word(AnkiAPI.word_source)
		fsm.next_state = fsm.states.input
	else:
		object.show_error("[wave][b]Failed to connect to Anki![/b][/wave]\nMake sure Anki and AnkiConnect server are running!\nThen open a deck to review and click [code]Enter[/code] to proceed.")
