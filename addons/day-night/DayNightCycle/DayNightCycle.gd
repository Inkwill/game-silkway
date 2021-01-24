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
	if err : push_error("GameDate connect err[%s] from DayNightCycle"%err)
	color = _get_color()

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
	if quarter <= cycle["day"] or quarter >=96-cycle["day"]: return color_day
	elif quarter <= cycle["dusk_s"] : return lerp(color_dusk,color_day,(cycle["dusk_s"] - quarter)/(cycle["dusk_s"]-cycle["day"]))
	elif quarter <= cycle["dusk_e"] : return lerp(color_night,color_dusk,(cycle["dusk_e"] - quarter)/(cycle["dusk_e"]-cycle["dusk_s"]))
	elif quarter >= cycle["dawn_e"] : return lerp(color_dawn,color_day,(quarter - cycle["dawn_e"])/(96-cycle["day"]-cycle["dawn_e"]))
	elif quarter >= cycle["dawn_s"] : return lerp(color_night,color_dawn,(quarter - cycle["dawn_s"])/(cycle["dawn_e"]-cycle["dawn_s"]))
	else :return color_night

