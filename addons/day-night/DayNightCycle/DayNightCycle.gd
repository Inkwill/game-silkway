extends CanvasModulate

export (Color) var color_night = Color(0.07, 0.09, 0.38, 1.0)
export (Color) var color_dawn = Color(0.86, 0.70, 0.70, 1.0)
export (Color) var color_day = Color(1.0, 1.0, 1.0, 1.0)
export (Color) var color_dusk = Color(0.59, 0.66, 0.78, 1.0)
export (int) var delay = 0

onready var color_transition_tween = $ColorTransitionTween
var date

func _ready():
	date = host.account.date
	# Connect signals.
	var current_cycle_changed_signal = date.connect(
		"current_cycle_changed",
		self,
		"_on_current_cycle_changed"
	)

	# Set the current cycle state.
	match date.current_cycle:
		date.CycleState.NIGHT:
			color = color_night
		date.CycleState.DAWN:
			color = color_dawn
		date.CycleState.DAY:
			color = color_day
		date.CycleState.DUSK:
			color = color_dusk

# CALLBACKS
# ---------
func _on_current_cycle_changed():
	match date.current_cycle:
		date.CycleState.NIGHT:
			if delay > 0:
				yield(get_tree().create_timer(delay), "timeout")
			color_transition_tween.interpolate_property(
				self,
				"color",
				color_dusk,
				color_night,
				date.state_transition_duration,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			color_transition_tween.start()
		date.CycleState.DAWN:
			if delay > 0:
				yield(get_tree().create_timer(delay), "timeout")
			color_transition_tween.interpolate_property(
				self,
				"color",
				color_night,
				color_dawn,
				date.state_transition_duration,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			color_transition_tween.start()
		date.CycleState.DAY:
			if delay > 0:
				yield(get_tree().create_timer(delay), "timeout")
			color_transition_tween.interpolate_property(
				self,
				"color",
				color_dawn,
				color_day,
				date.state_transition_duration,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			color_transition_tween.start()
		date.CycleState.DUSK:
			if delay > 0:
				yield(get_tree().create_timer(delay), "timeout")

			color_transition_tween.interpolate_property(
				self,
				"color",
				color_day,
				color_dusk,
				date.state_transition_duration,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			color_transition_tween.start()
