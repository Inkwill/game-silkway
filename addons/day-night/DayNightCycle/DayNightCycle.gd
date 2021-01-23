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
	color = _get_color()
# CALLBACKS
# ---------
func _on_timer_step(_delta):
	tween.interpolate_property(
				self,
				"color",
				color,
				_get_color(),
				_delta * date.timer_unit,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
	if not tween.is_active(): tween.start()
	
func _get_color():
	var quarter = fmod(host.account.curday,1)*96
	var cycle = host.account.world.get_aero().sunshine_cycle()
	if  abs(48 -quarter)<= cycle["day"] : return color_day
	elif abs(quarter-48)>= cycle["night"] : return color_night
	elif quarter <= cycle["dawn"] : return lerp(color_night,color_dawn, (quarter-48+cycle["night"])/(cycle["dawn"]-48+cycle["night"]))
	elif quarter < 48 : return lerp(color_dawn,color_day, (quarter-cycle["dawn"])/(48-cycle["day"]-cycle["dawn"]))
	elif quarter >= cycle["dusk"] : return lerp(color_dusk,color_night,(quarter-cycle["dusk"])/(48+cycle["night"]-cycle["dusk"]))
	else:return lerp(color_day,color_dusk,(quarter- 48 - cycle["day"])/(cycle["dusk"]-48 - cycle["day"]))
