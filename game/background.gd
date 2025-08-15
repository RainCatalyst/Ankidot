extends ColorRect

@export var wave_a_good: Color
@export var wave_b_good: Color
@export var wave_a_bad: Color
@export var wave_b_bad: Color
@export var sparks: CPUParticles2D
@export var sparks_bad: CPUParticles2D


var tween: Tween

func reset_bg():
	if tween and tween.is_valid():
		tween.kill()

	tween = create_tween()

	var duration = 1.0
	tween.tween_property(material, "shader_parameter/wave", 3, duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)

func do_wave():
	# Remove old tween if it exists
	if tween and tween.is_valid():
		tween.kill()

	# Create a new tween
	tween = create_tween()

	var duration = 0.7
	material.set_shader_parameter("wave_color_a", wave_a_good)
	material.set_shader_parameter("wave_color_b", wave_b_good)
	
	# 1. "wave" from 0 → 1 with easing
	material.set_shader_parameter("wave", 1.25)
	tween.tween_property(material, "shader_parameter/wave", 0.8, duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	#sparks.emitting = true
		
func do_wave_bad():
	# Remove old tween if it exists
	if tween and tween.is_valid():
		tween.kill()

	# Create a new tween
	tween = create_tween()

	var duration = 0.7
	material.set_shader_parameter("wave_color_a", wave_a_bad)
	material.set_shader_parameter("wave_color_b", wave_b_bad)
	# 1. "wave" from 0 → 1 with easing
	material.set_shader_parameter("wave", -1.25)
	tween.tween_property(material, "shader_parameter/wave", 0.8, duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	#sparks_bad.emitting = true

	# 2. "wave_amount" 0 → 1 → 0 over same total duration (1 sec)
	#material.set_shader_parameter("wave_amount", 0.0)
	#tween.parallel().tween_property(material, "shader_parameter/wave_amount", 1.0, duration * 0.5)\
		#.set_trans(Tween.TRANS_SINE)\
		#.set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(material, "shader_parameter/wave_amount", 0.0, duration * 0.5)\
		#.set_trans(Tween.TRANS_SINE)\
		#.set_ease(Tween.EASE_IN_OUT)

#func do_wave():
	## Remove old tween if it exists
	#if tween and tween.is_valid():
		#tween.kill()
#
	## Create a new tween
	#tween = create_tween()
#
	#var duration = 1.8
	#material.set_shader_parameter("wave_color_a", wave_a_good)
	#material.set_shader_parameter("wave_color_b", wave_b_good)
	#
	## 1. "wave" from 0 → 1 with easing
	#material.set_shader_parameter("wave", 1.25)
	#tween.tween_property(material, "shader_parameter/wave", -2.25, duration)\
		#.set_trans(Tween.TRANS_QUAD)\
		#.set_ease(Tween.EASE_OUT)
		#
	#sparks.emitting = true
		#
#func do_wave_bad():
	## Remove old tween if it exists
	#if tween and tween.is_valid():
		#tween.kill()
#
	## Create a new tween
	#tween = create_tween()
#
	#var duration = 1.0
	#material.set_shader_parameter("wave_color_a", wave_a_bad)
	#material.set_shader_parameter("wave_color_b", wave_b_bad)
	## 1. "wave" from 0 → 1 with easing
	#material.set_shader_parameter("wave", -1.0)
	#tween.tween_property(material, "shader_parameter/wave", 2.5, duration)\
		#.set_trans(Tween.TRANS_QUAD)\
		#.set_ease(Tween.EASE_OUT)
		#
	#sparks_bad.emitting = true
