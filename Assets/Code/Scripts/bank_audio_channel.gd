extends AudioStreamPlayer2D

var start_volume_db
var tween
var ending = false
var fading := false
var last_fade_duration := 0.0

func fade_volume(target_volume_db, fade_duration):
	print("Begin Fade at ", self)
	if fading:
		push_warning("[bank_audio_channel] Warning: Attempted new fade during ongoing fade at ", tween)
		return
	if !fading:
		last_fade_duration = fade_duration
		fading = true
		tween = get_tree().create_tween() 
		print("Called Fadevolume: ", target_volume_db, " ", fade_duration)
		tween.tween_property(self, "volume_db", target_volume_db, fade_duration)
		tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	if tween != null:
		tween.kill()  # Stop any active tweens on this instance
		fading = false
		print("Killed tween: ", tween)
	
		if ending:
			stop()
			stream = null
			ending = false
			print("Stopped, Set stream to null.")

	# You can add other actions here if needed

func stop_fade():
	_on_tween_finished()

func is_ready() -> int:
	if playing:
		push_warning("[bank_audio_channel] Channel, ", self, " Still playing.")
		return 1
	if tween != null and tween.is_running() == true:
		push_warning("[bank_audio_channel] Channel: ", self, " with Tween ", tween, " Tween still running.")
		return 2
	if ending:
		push_warning("[bank_audio_channel] Channel: ", self, " has not ended yet.")
		return 3
	return 0

func start():
	if tween != null and tween.is_running() == true:
		printerr("[bank_audio_channel] Error: Can't start while fading!: ", tween)
		return
	if playing:
		printerr("[bank_audio_channel] Error: Play attempt while already playing.")
		return
	if ending:
		printerr("[bank_audio_channel] Error: Play attempt during Fadeout.")
		return
	if stream == null:
		return
	play()
	fade_volume(start_volume_db, 0.1)
	print("start playing with :", start_volume_db)
	return

func end():
	if !playing:
		return
	ending = true
	fade_volume(-60.0, 1)
	

func _process(delta):
	if ending:
		await get_tree().create_timer(3.0).timeout
		if ending and playing:
			push_error(self, " ", tween, " was meant to fade out and stop. It hasn't. Killing tween.")
			_on_tween_finished()
	
	if fading:
		await get_tree().create_timer(1).timeout
		await get_tree().create_timer(last_fade_duration).timeout
		if fading:
			push_warning(self, " ",  tween, " was meant to fade for ", last_fade_duration, " and stop. It hasn't. Killing tween.")
			_on_tween_finished()

