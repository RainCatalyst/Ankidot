extends State

var message: String

func enter(from_state: State):
	object.background.do_wave_bad()
	object.error_label.show()
	object.error_label.text = message
	object.mistake_bar.hide()

func exit(to_state: State):
	object.error_label.hide()
	object.mistake_bar.show()

func process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		fsm.next_state = fsm.states.next_word
