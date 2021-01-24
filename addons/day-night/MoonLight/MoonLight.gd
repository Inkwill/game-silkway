extends Light2D

# 朔月 日昇日落 crescent energy = 0
# 新月 上半夜 new
# 上弦 午時子時 up 
# 滿月 日落日昇 full energy = 1
# 下弦 子時午時 down 
# 殘月 下半夜 set

# 初一 朔月 
# 初二至初八 峨眉(新)月 - 上弦月  傍晚 - 夜半 西天空
# 初八至十五四 上弦月 - 凸月 傍晚 - 夜半 - 黎明 
# 十五至十六 望月 傍晚 - 黎明  東昇西落 
# 十七至廿三 凸月-下弦月 傍晚 - 夜半 - 黎明 
# 廿四至廿九 下弦月-峨眉(殘月) 夜半-黎明 東天空

export (Color) var color_night = Color(1.0, 1.0, 1.0, 1.0)
export (float) var energy_night = 1.0
export (Color) var color_dawn = Color(1.0, 1.0, 1.0, 1.0)
export (float) var energy_dawn = 0.0
export (Color) var color_day = Color(1.0, 1.0, 1.0, 1.0)
export (float) var energy_day = 0.0
export (Color) var color_dusk = Color(1.0, 1.0, 1.0, 1.0)
export (float) var energy_dusk = 0.0


onready var color_transition_tween = $ColorTransitionTween
onready var energy_transition_tween = $EnergyTransitionTween

func _ready():
	# Connect signals.
	var err = host.account.date.connect("timer_step",self,"_on_timer_step")
	if err: printerr(err)

	# Set the current cycle state.
	color = _get_moon()[0]
	energy = _get_moon()[1]

func _on_timer_step(_delta):
	color_transition_tween.interpolate_property(
		self,
		"color",
		color,
		_get_moon()[0],
		_delta * host.account.date.timer_unit,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	if not color_transition_tween.is_active(): color_transition_tween.start()
	energy_transition_tween.interpolate_property(
		self,
		"energy",
		energy,
		_get_moon()[1],
		_delta * host.account.date.timer_unit,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	if not energy_transition_tween.is_active(): energy_transition_tween.start()

func _moon():
	var day = host.account.date.get_day(host.account.curday)
	if day < 8 : return "new"
	elif day <15 : return "up"
	elif day ==15 : return "full"
	elif day <23 : return "down"
	else : return ""
		

func _get_moon():
	var quarter = fmod(host.account.curday,1)*96
	var cycle = host.account.world.get_aero().sunshine_cycle()
	if quarter <= cycle["day"] or quarter >=96-cycle["day"]: return [color_day,energy_day]
	elif quarter <= cycle["dusk_s"] : return [lerp(color_dusk,color_day,(cycle["dusk_s"] - quarter)/(cycle["dusk_s"]-cycle["day"])),energy_dusk]
	elif quarter <= cycle["dusk_e"] : return [lerp(color_night,color_dusk,(cycle["dusk_e"] - quarter)/(cycle["dusk_e"]-cycle["dusk_s"])),energy_dusk]
	elif quarter >= cycle["dawn_e"] : return [lerp(color_dawn,color_day,(quarter - cycle["dawn_e"])/(96-cycle["day"]-cycle["dawn_e"])),energy_dawn]
	elif quarter >= cycle["dawn_s"] : return [lerp(color_night,color_dawn,(quarter - cycle["dawn_s"])/(cycle["dawn_e"]-cycle["dawn_s"])),energy_dawn]
	else :return [color_night,energy_night]
