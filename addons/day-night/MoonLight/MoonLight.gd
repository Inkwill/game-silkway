extends Light2D

export (Color) var color_night = Color(1.0, 1.0, 1.0, 1.0)
export (float) var energy_night = 1.0
export (Color) var color_dawn = Color(1.0, 1.0, 1.0, 1.0)
export (float) var energy_dawn = 0.0
export (Color) var color_day = Color(1.0, 1.0, 1.0, 1.0)
export (float) var energy_day = 0.0
export (Color) var color_dusk = Color(1.0, 1.0, 1.0, 1.0)
export (float) var energy_dusk = 0.0
export (bool) var move_moon = false
export (NodePath) var cycle_sync_node_path
export (bool) var static_moon = true
export (bool) var use_hour_position = false
export (int, 0, 23) var hour_position = 0

var window_x: float = ProjectSettings.get_setting("display/window/size/width")
var window_y: float = ProjectSettings.get_setting("display/window/size/height")

var window_center := Vector2(window_x / 2, window_y / 2)
var radius_x: float = window_x / 2.10
var radius_y: float = window_y / 2.15

var path := Curve2D.new()

var speed: float
var hour_step: float
var moon_position: float

var cycle_sync_node: Node

onready var color_transition_tween = $ColorTransitionTween
onready var energy_transition_tween = $EnergyTransitionTween

func _ready():
	if static_moon and move_moon or not static_moon and not move_moon:
		printerr("--------------------")
		printerr("ERROR!")
		printerr("File: '%s.gd'."  % self.name)
		printerr("Message: The 'static_moon' and 'move_moon' variables can't" + \
				" both be set to 'true' or 'false' at the same time.")
		printerr("--------------------")

		# Reset the path so in case there is a 'DebugOverlay' node,
		# there won't be any options for the 'MoonLight' node.
		cycle_sync_node_path = ""

		return

	# Connect signals.
	var current_hour_changed_signal = host.account.date.connect(
		"timer_step",
		self,
		"_on_timer_step"
	)

	# Check if signals are connected correctly.
	if current_hour_changed_signal != OK:
		printerr(current_hour_changed_signal)



	# Create the path.
	path.add_point(window_center + Vector2(0, -radius_y), Vector2(-radius_x, 0))
	path.add_point(window_center + Vector2(radius_x, 0), Vector2(0, -radius_y))
	path.add_point(window_center + Vector2(0, radius_y), Vector2(radius_x, 0))
	path.add_point(window_center + Vector2(-radius_x, 0), Vector2(0, radius_y))
	path.add_point(window_center + Vector2(0, -radius_y), Vector2(-radius_x, 0))

	# Sync the speed with in-game time.
	speed = path.get_baked_points().size() / \
			(60.0*60.0*24 / 5400)

	# Divide the path into hours.
	hour_step = path.get_baked_points().size() / 24.0

	if move_moon:
		if cycle_sync_node_path:
			cycle_sync_node = get_node(cycle_sync_node_path)

			# Make it visible in case it's hidden in the editor.
			visible = true

			moon_position = hour_step * GameDate.get_time(host.account.cur_day)
			position = path.get_baked_points()[moon_position]
		else:
			printerr("--------------------")
			printerr("ERROR!")
			printerr("File: '%s.gd'."  % self.name)
			printerr("Message: The '" + str(self.name) + "' node isn't" + \
					" sync with any 'DayNightCycle' node." + \
					" Use the 'cycle_sync_node_path' variable in the '" + \
					str(self.name) + "' node to sync it with a 'DayNightCycle' node.")
			printerr("--------------------")

			visible = false
			return
			
	elif static_moon:
		set_physics_process(false)

		# Make it visible in case it's hidden in the editor.
		visible = true

		if use_hour_position:
			moon_position = hour_step * hour_position
			position = path.get_baked_points()[moon_position]

	# Set the current cycle state.
	var quarter = fmod(host.account.curday,1)*96
	var cycle = host.account.world.get_aero().sunshine_cycle()
	if  abs(48 -quarter)<= cycle["day"] :
		color = color_day
		energy = energy_day
	elif abs(quarter-48)>= cycle["night"] : 
		color = color_night
		energy = energy_night
	elif quarter >= cycle["dusk"] :
		color = color_dusk
		energy = energy_dusk
	else :
		color = color_dawn
		energy = energy_dawn
	

func _physics_process(delta):
	_move_moon(delta)

# PRIVATE FUNCTIONS
# -----------------
func _move_moon(delta):
	if moon_position + (delta * speed) >= path.get_baked_points().size():
		moon_position += (delta * speed) - path.get_baked_points().size()
	else:
		position = path.get_baked_points()[moon_position]
		moon_position += delta * speed


# CALLBACKS
# ---------
#func _on_current_cycle_changed():
#	match host.account.date.current_cycle:
#		host.account.date.CycleState.NIGHT:
#			color_transition_tween.interpolate_property(
#				self,
#				"color",
#				color_dusk,
#				color_night,
#				host.account.date.state_transition_duration,
#				Tween.TRANS_SINE,
#				Tween.EASE_OUT
#			)
#			color_transition_tween.start()
#
#			energy_transition_tween.interpolate_property(
#				self,
#				"energy",
#				energy_dusk,
#				energy_night,
#				host.account.date.state_transition_duration,
#				Tween.TRANS_SINE,
#				Tween.EASE_OUT
#			)
#			energy_transition_tween.start()
#		host.account.date.CycleState.DAWN:
#			color_transition_tween.interpolate_property(
#				self,
#				"color",
#				color_night,
#				color_dawn,
#				host.account.date.state_transition_duration,
#				Tween.TRANS_SINE,
#				Tween.EASE_OUT
#			)
#			color_transition_tween.start()
#
#			energy_transition_tween.interpolate_property(
#				self,
#				"energy",
#				energy_night,
#				energy_dawn,
#				host.account.date.state_transition_duration,
#				Tween.TRANS_SINE,
#				Tween.EASE_OUT
#			)
#			energy_transition_tween.start()
#		host.account.date.CycleState.DAY:
#			color_transition_tween.interpolate_property(
#				self,
#				"color",
#				color_dawn,
#				color_day,
#				host.account.date.state_transition_duration,
#				Tween.TRANS_SINE,
#				Tween.EASE_OUT
#			)
#			color_transition_tween.start()
#
#			energy_transition_tween.interpolate_property(
#				self,
#				"energy",
#				energy_dawn,
#				energy_day,
#				host.account.date.state_transition_duration,
#				Tween.TRANS_SINE,
#				Tween.EASE_OUT
#			)
#			energy_transition_tween.start()
#		host.account.date.CycleState.DUSK:
#			color_transition_tween.interpolate_property(
#				self,
#				"color",
#				color_day,
#				color_dusk,
#				host.account.date.state_transition_duration,
#				Tween.TRANS_SINE,
#				Tween.EASE_OUT
#			)
#			color_transition_tween.start()
#
#			energy_transition_tween.interpolate_property(
#				self,
#				"energy",
#				energy_day,
#				energy_dusk,
#				host.account.date.state_transition_duration,
#				Tween.TRANS_SINE,
#				Tween.EASE_OUT
#			)
#			energy_transition_tween.start()

func _on_timer_step(_delta):
	if move_moon:
		moon_position = hour_step * GameDate.get_time(host.account.cur_day)
		position = path.get_baked_points()[moon_position]

