extends Control

const SIMULATED_DELAY_SEC = 0.1
signal _load_finished
var thread = null

onready var progress = $progress

func _thread_load(path):
	var ril = ResourceLoader.load_interactive(path)
	assert(ril)
	var total = ril.get_stage_count()
	# Call deferred to configure max load steps.
	progress.call_deferred("set_max", total)

	var res = null

	while true: #iterate until we have a resource
		# Update progress bar, use call deferred, which routes to main thread.
		progress.call_deferred("set_value", ril.get_stage())
		# Simulate a delay.
		OS.delay_msec(int(SIMULATED_DELAY_SEC * 1000.0))
		# Poll (does a load step).
		var err = ril.poll()
		# If OK, then load another one. If EOF, it' s done. Otherwise there was an error.
		if err == ERR_FILE_EOF:
			# Loading done, fetch resource.
			res = ril.get_resource()
			progress.value = total
			break
		if err != OK:
			push_error("Loading res err : %s" % path)
			break
	assert(res)
#	thread.wait_to_finish()
#	call_deferred("emit_signal","_load_finished",res)
	emit_signal("_load_finished",res)	
			
func load_res(path):
	thread = Thread.new()
	thread.start( self, "_thread_load", path)
	progress.visible = true

func _exit_tree():
	thread.wait_to_finish()
