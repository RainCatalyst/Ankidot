extends Control
class_name Game

@export var word_label: WordLabel
@export var error_label: RichTextLabel
@export var input_label: InputLabel
@export var background: ColorRect
@export var mistake_bar: MistakeBar
@export var result_label: ResultLabel
@export var ui_pivot: Control

@onready var fsm = StateMachine.new(self, $States, $States/idle, false)

var last_correct: bool = false
var last_ease: int = 1.0
var incorrect_times: int = 0
var error_msg: String = ""

var shake_amount: float = 0.0
var shake_smooth: float = 8.0

func _ready():
	Global.game = self
	mistake_bar.setup(3)
	
func shake(smooth: float = 8.0):
	shake_amount = 250.0
	shake_smooth = smooth
	
func set_word(word: String):
	word_label.set_text(word)
	incorrect_times = 0
	mistake_bar.reset()
	
func show_error(msg: String):
	fsm.states.error.message = msg
	fsm.next_state = fsm.states.error
	
func guess_correct():
	last_correct = true
	last_ease = 4 - incorrect_times
	background.do_wave()
	fsm.next_state = fsm.states.answer
	
func guess_wrong():
	last_correct = false
	incorrect_times += 1
	shake()
	background.do_wave_bad()
	mistake_bar.reduce()
	last_ease = 1.0
	if incorrect_times >= 3:
		fsm.next_state = fsm.states.answer

func _process(delta):
	fsm.process(delta)
	if shake_amount > 0.0:
		ui_pivot.position = lerp(ui_pivot.position, Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_amount, shake_smooth * delta)
		shake_amount = lerp(shake_amount, 0.0, delta * 12)
		if shake_amount < 0.5:
			ui_pivot.position = Vector2.ZERO
			shake_amount = 0.0
