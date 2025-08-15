extends Node

# Signals
signal word_data_received(success: bool)
signal answer_data_received(success: bool)
signal answer_sent(success: bool)

# Constants
const ANKI_CONNECT_URL := "http://127.0.0.1:8765"
const API_VERSION := 6
const MAX_TYPOS := 2

# State
var word_source: String = ""
var word_target: String = ""
var valid_answers: Array[String] = []

@onready var http_request: HTTPRequest = $HTTPRequest

var _request_callback: Callable

# Debug
@export var debug_label: RichTextLabel
@onready var debug_canvas := $CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		debug_canvas.visible = not debug_canvas.visible
	if debug_canvas.visible:
		debug_label.text = "Source: [b]%s[/b]\nTarget: [b]%s[/b]\nValid answers: [b]%s[/b]" % [word_source, word_target, valid_answers]

func request_word_data() -> void:
	print("Requesting current card data")
	send_request({
		"action": "guiCurrentCard",
		"version": API_VERSION
	}, _on_word_data_received)


func request_answer() -> void:
	send_request({
		"action": "guiShowAnswer",
		"version": API_VERSION
	}, func(result: int, code: int, data: Dictionary):
		answer_data_received.emit(code == 200)
	)


func send_answer(ease: int) -> void:
	send_request({
		"action": "guiAnswerCard",
		"version": API_VERSION,
		"params": {"ease": ease}
	}, func(result: int, code: int, data: Dictionary):
		answer_sent.emit(code == 200)
	)


func is_word_correct(input: String) -> bool:
	var user_input := input.to_lower()
	var target_lower := word_target.to_lower()
	
	if user_input == target_lower:
		return true
	if user_input in valid_answers:
		return true
	
	var possible_variations := [
		user_input,
		user_input + "s",
		user_input.rstrip("s"),
		"to " + user_input,
		"to be " + user_input,
		"be " + user_input,
		user_input.replace("to ", "")
	]
	
	var max_typos: int = MAX_TYPOS
	if len(target_lower) < 4:
		max_typos = 1
	
	for variation in possible_variations:
		if variation == target_lower:
			return true
		if variation in valid_answers:
			return true
		if TextUtils.is_similar(variation, target_lower, max_typos):
			return true
	
	for answer in valid_answers:
		if TextUtils.is_similar(user_input, answer, max_typos):
			return true
	
	return false


func send_request(payload: Dictionary, callback: Callable) -> void:
	if http_request.is_connected("request_completed", _on_request_completed_wrapper):
		http_request.disconnect("request_completed", _on_request_completed_wrapper)
	
	_request_callback = callback
	http_request.connect("request_completed", _on_request_completed_wrapper)
	
	var json_payload := JSON.stringify(payload)
	var headers := [
		"Content-Type: application/json",
		"Content-Length: %d" % json_payload.length()
	]
	
	var error := http_request.request(
		ANKI_CONNECT_URL,
		headers,
		HTTPClient.METHOD_POST,
		json_payload
	)
	
	if error != OK:
		push_error("Failed to start HTTP request: %s" % error)
		_request_callback.call(error, 0, {})


func _on_request_completed_wrapper(
	result: int,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	var json_result := {}
	var body_str := body.get_string_from_utf8()
	
	if body_str != "":
		var parsed = JSON.parse_string(body_str)
		if typeof(parsed) in [TYPE_DICTIONARY, TYPE_ARRAY]:
			json_result = parsed
	
	if _request_callback.is_valid():
		_request_callback.call(result, response_code, json_result)
	
	http_request.disconnect("request_completed", _on_request_completed_wrapper)


func _on_word_data_received(result: int, code: int, json_result: Dictionary) -> void:
	if code != 200 or not json_result.has("result") or json_result["result"] == null:
		word_data_received.emit(false)
		return

	var card_data: Dictionary = json_result.get("result", {})
	if not card_data.has("fields"):
		word_data_received.emit(false)
		return
	
	word_source = card_data.fields.Vocab.value
	word_target = card_data.fields["Vocab-English"].value
	valid_answers = TextUtils.parse_valid_answers(word_target)
	
	word_data_received.emit(true)
