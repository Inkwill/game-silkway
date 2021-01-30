extends Control
class_name UIWindow

var tween
export(Vector2) var view_size
export(Vector2) var tw_from
export(Vector2) var tw_to
export(float) var tw_duration

var window_scale
var is_open = false

signal s_close

func _ready():
	window_scale = get_viewport().size/view_size
	var err = get_viewport().connect("size_changed", self, "_on_root_size_changed")
	if err : push_warning("Connect err : _on_root_size_changed")
	show_open()

func show_open():
	is_open = true
	tween = GUITools.tween_postion(self,tw_from*window_scale, tw_to*window_scale, tw_duration)

func show_close():
	is_open = false
	tween = GUITools.tween_postion(self,tw_to*window_scale, tw_from*window_scale, tw_duration,"queue_free")
	emit_signal("s_close")

static func open_window(_root,_path,_duration=1):
	var win = load(_path).instance()
	if _root.has_node(win.name) : return _root.get_node(win.name)
	win.tw_duration = _duration
	_root.add_child(win)
#	var err = win.tween.connect("tween_step",_root,"_on_window_tween")
#	if err : push_error("Connect UIWindow tween err[%s] from %s"% [err,_root])
#	err = win.tween.connect("tween_started",_root,"_on_window_start")
#	if err : push_error("Connect UIWindow tween err[%s] from %s"% [err,_root])
#	err = win.tween.connect("tween_completed",_root,"_on_tween_completed")
#	if err : push_error("Connect UIWindow tween err[%s] from %s"% [err,_root])
	return win
	
func _on_root_size_changed():
	window_scale = get_viewport().size/view_size