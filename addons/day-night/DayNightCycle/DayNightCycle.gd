extends CanvasModulate

export (Color) var color_night = Color(0.07, 0.09, 0.38, 1.0)
export (Color) var color_dawn = Color(0.86, 0.70, 0.70, 1.0)
export (Color) var color_day = Color(1.0, 1.0, 1.0, 1.0)
export (Color) var color_dusk = Color(0.59, 0.66, 0.78, 1.0)

onready var tween = $ColorTransitionTween
var date

func _ready():
	date = host.account.date
	# Connect signals.
	var err = date.connect("timer_step",self,"_on_timer_step")
	color = _get_color(host.account.curday)
# CALLBACKS
# ---------
func _on_timer_step(_delta):
	tween.interpolate_property(
				self,
				"color",
				color,
				_get_color(host.account.curday),
				_delta * date.timer_unit,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
	if not tween.is_active(): tween.start()
	
func _get_color(jdate):
	match GameDate.get_time(jdate):
		0,1,2,3:return color_day
		4,5:return color_dusk
		6,7,8,9:return color_night
		10,11:return color_dawn
		_:return color
