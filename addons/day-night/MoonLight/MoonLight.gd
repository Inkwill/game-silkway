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
var radius = 300 # rate of window
var center = Vector2(0.5,0.2)  # rate of window
onready var tween = $MoonPositionTween

func _ready():
	# Connect signals.
	var err = host.account.date.connect("timer_step",self,"_on_timer_step")
	if err: printerr(err)

	# Set the base energy by day.
	energy = sin(PI*host.account.date.get_day(host.account.curday)/29)
	color = Color(1.0,1.0,1.0,1.0)
	position = cur_moon_position()
	center = Vector2(get_tree().root.size.x * center.x,get_tree().root.size.y * center.y)

func _on_timer_step(_delta):
	energy = sin(PI*host.account.date.get_day(host.account.curday)/29)
	tween.interpolate_property(
		self,
		"position",
		position,
		cur_moon_position(),
		_delta * host.account.date.timer_unit,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	if not tween.is_active(): tween.start()

func cur_moon_position():
	var day = host.account.date.get_day(host.account.curday)
	var quarter = fmod(host.account.curday,1)*96
	var pos_rise = lerp(0,2.0,day/28.0)
	var angle = lerp(pos_rise*PI,(pos_rise+2)*PI, (quarter-24.0)/96.0) #當前夾角
	var pos = center - Vector2(-radius*cos(angle),radius*sin(angle))  # mirror
	return pos  

