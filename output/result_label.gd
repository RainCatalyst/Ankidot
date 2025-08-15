class_name ResultLabel extends WordLabel

@export var colors: Array[Color]
@export var labels: Array[String]

func _ready():
	MIN_SIZE_X = 0
	PAD = Vector2(40, 10)
	super()
	hide_result()

func show_result(ease: int):
	modulate = colors[ease - 1]
	set_text(labels[ease - 1])

func hide_result():
	hide_text()
