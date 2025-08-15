extends State

var t: float = 0.0
var have_answer: bool = false
var sent_answer: bool = false

func post_setup():
	AnkiAPI.answer_data_received.connect(_on_answer_received)
	AnkiAPI.answer_sent.connect(_on_answer_sent)

func enter(from_state: State):
	have_answer = false
	sent_answer = false
	AnkiAPI.request_answer()
	object.input_label.show_answer(AnkiAPI.word_target, object.last_correct)
	object.result_label.show()
	object.result_label.show_result(object.last_ease)
	object.mistake_bar.hide()
	t = 0.0

func exit(to_state: State):
	object.input_label.clear()
	object.result_label.hide_result()
	object.result_label.hide()
	object.mistake_bar.show()

func process(delta):
	t += delta
	if t >= 0.1 and have_answer and Input.is_action_just_pressed("ui_accept"):
		AnkiAPI.send_answer(object.last_ease)
		have_answer = false

func _on_answer_received(success: bool):
	have_answer = true

func _on_answer_sent(success: bool):
	sent_answer = true
	fsm.next_state = fsm.states.next_word
	
