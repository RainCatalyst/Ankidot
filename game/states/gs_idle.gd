extends State

func process(delta):
	fsm.next_state = fsm.states.next_word
