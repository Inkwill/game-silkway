extends Control
class_name UIWindow

onready var tween = $Tween
export(Vector2) var view_size
export(Vector2) var tw_from
export(Vector2) var tw_to
export(float) var tw_duration

var window_scale
var is_open = false

func _ready():
	window_scale = get_viewport().size/view_size
	var err = get_viewport().connect("size_changed", self, "_on_root_size_changed")
	if err : push_warning("Connect err : _on_root_size_changed")
	show_open()

func show_open():
	is_open = true
	tween.interpolate_property(self,"rect_position",tw_from*window_scale, tw_to*window_scale, tw_duration,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_callback(self, 5+tw_duration,"show_close")
	if not tween.is_active():tween.start()

func show_close():
	is_open = false
	tween.interpolate_property(self,"rect_position",tw_to*window_scale, tw_from*window_scale, tw_duration,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_callback(self, tw_duration,"queue_free")
	if not tween.is_active():tween.start()

func _on_root_size_changed():
	window_scale = get_viewport().size/view_size
#
static func open_window(_root,_path,_duration=1):
	var win = load(_path).instance()
	if host.root.has_node(win.name) : return
	win.tw_duration = _duration
	host.root.add_child(win)
	var err = win.tween.connect("tween_step",_root,"_on_tween_step")
	if err : push_error("Connect UIWindow tween err[%s] from %s"% [err,_root])
	err = win.tween.connect("tween_started",_root,"_on_tween_started")
	if err : push_error("Connect UIWindow tween err[%s] from %s"% [err,_root])
	err = win.tween.connect("tween_completed",_root,"_on_tween_completed")
	if err : push_error("Connect UIWindow tween err[%s] from %s"% [err,_root])
