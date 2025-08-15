extends Control
class_name MistakeBar

@export var mistake_box: PackedScene

var boxes: Array[MistakeBox]
var mistakes: int = 0
var center: Vector2

const BOX_SIZE := 32.0
const PAD := 10.0

func setup(count: int):
	boxes = []
	center = size / 2 - Vector2(BOX_SIZE, BOX_SIZE) / 2
	
	for i in range(count):
		var inst = mistake_box.instantiate()
		add_child(inst)
		inst.position = center + Vector2(BOX_SIZE + PAD, 0) * float(i - count / 2)
		inst.set_target_pos(inst.position)
		boxes.append(inst)

func reduce():
	if mistakes > len(boxes):
		return
	boxes[len(boxes) - 1 - mistakes].toggle_off()
	#var left = len(boxes) - mistakes - 1
	#for i in range(left):
		#boxes[i].set_target_pos(center + Vector2(BOX_SIZE + PAD, 0) * float(i - left / 2))
	mistakes += 1

func reset():
	for i in range(mistakes):
		boxes[len(boxes) - 1 - i].toggle_on((mistakes - i - 1) * 0.07)
	#for i in range(len(boxes)):
		#boxes[i].set_target_pos(center + Vector2(BOX_SIZE + PAD, 0) * float(i - len(boxes) / 2))
	mistakes = 0
