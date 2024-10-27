class_name DynamicAudio
extends Node2D

## Dynamic Audio Manager
## Provides functions to run up to 6 audio files at the same time.
##It provides 2 banks and easy control over which ever one is playing.
##this allows you to play tracks, change volume on those, while loading in another set.
##first call: func prepare_new_bank(files: Array, volumes: Array, loop_local: Array):
## with an array of paths to ogg files, an array of volume_db values to start playing at and loop yes or no, and looop offset
## func play_prepared_bank() -> int: will return 0 if it successfully plays audio

signal prepared_bank(bank)
signal started_playing(bank)




var next := [ "", "", "", "", "", ""]
var starting_volume := [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
var loop = [false, null]
var currently_playing := "A"
var finished_preparation := false
var started_preparation := false

@onready var bank_a = [$BankA/BankA1, $BankA/BankA2,\
						$BankA/BankA3, $BankA/BankA4,\
						$BankA/BankA5, $BankA/BankA6]
@onready var bank_b = [$BankB/BankB1, $BankB/BankB2, $BankB/BankB3, $BankB/BankB4, $BankB/BankB5, $BankB/BankB6]


func _set_finished_default():
	starting_volume = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
	next = ["", "", "", "", "", ""]
	loop = [false, null]
	finished_preparation = true
	started_preparation = false


func _set_defaults():
	starting_volume = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
	next = ["", "", "", "", "", ""]
	loop = [false, null]


func _prepare_play():
	print("Called Prepare Play")
	if currently_playing == "A":
		started_preparation = true
		print("Preparing Bank B")
		for n in 6:
			if next[n] == "":
				bank_b[n].stream = null
			if next[n] != "":
				print("Preparing: ", n)
				bank_b[n].stream = load(next[n])
				bank_b[n].stream.loop = loop[0]
				if loop[1] != null:
					bank_b[n].stream.loop_offset = loop[1]
				bank_b[n].start_volume_db = starting_volume[n]
				prepared_bank.emit("B")
		_set_finished_default()
		print("Finished Prepareing Bank B")
		return


	if currently_playing == "B":
		started_preparation = true
		for n in 6:
			if next[n] == "":
				bank_a[n].stream = null
			if next[n] != "":
				bank_a[n].stream = load(next[n])
				bank_a[n].stream.loop = loop[0]
				if loop[1] != null:
					bank_a[n].stream.loop_offset = loop[1]
				bank_a[n].start_volume_db = starting_volume[n]
				prepared_bank.emit("A")
		_set_finished_default()
		print("Finished Prepareing Bank A")
		return
	push_error("[dynamic_audio] Error: Wrong or undefined currently_playing string")


func _switchover_play():
	if !finished_preparation:
		printerr("[dynamic_audio] Error: Can't initiate switchover. No new bank prepared.")
		return

	print("Begin Switchover Play")
	if currently_playing == "A":
		print("Swichover to B")
		for n in 6:
			print("Stopping A: ", n)
			bank_a[n].end()

		print("Ending Signals sent to A. ")
		if bank_b[0].is_ready() == 3 or bank_b[1].is_ready() == 3 or bank_b[2].is_ready() == 3 or \
		bank_b[3].is_ready() == 3 or  bank_b[4].is_ready() == 3 or bank_b[5].is_ready() == 3:
			push_warning("[Warning: One or more Bank B channels not ready. Delaying play.")
			await get_tree().create_timer(2.0).timeout
		if bank_b[0].is_ready() != 0 or bank_b[1].is_ready() != 0 or bank_b[2].is_ready() != 0 or\
		bank_b[3].is_ready() != 0 or  bank_b[4].is_ready() != 0 or bank_b[5].is_ready() != 0:
			push_warning("Warning: One or more Bank B channels not ready. Delaying play again.")
			await get_tree().create_timer(3.0).timeout
		if bank_b[0].is_ready() != 0 or bank_b[1].is_ready() != 0 or bank_b[2].is_ready() != 0 or\
		bank_b[3].is_ready() != 0 or  bank_b[4].is_ready() != 0 or bank_b[5].is_ready() != 0:
			push_error("Error: Bank B still not fully ready. Abort.")
			return

		bank_b[0].start()
		bank_b[1].start()
		bank_b[2].start()
		bank_b[3].start()
		bank_b[4].start()
		bank_b[5].start()
		currently_playing = "B"
		started_playing.emit("B")
		print("Swapped over to B. Finished")
		finished_preparation = false
		return

	if currently_playing == "B":
		print("Swichover to A")
		for n in 6:
			print("Stopping B: ", n)
			bank_b[n].end()
		print("Ending Signals sent to B. ")
		if bank_a[0].is_ready() == 3 or bank_a[1].is_ready() == 3 or bank_a[2].is_ready() == 3 or\
		bank_a[3].is_ready() == 3 or  bank_a[4].is_ready() == 3 or bank_a[5].is_ready() == 3:
			push_warning("One or more Bank A channels not ready. Delaying play.")
			await get_tree().create_timer(2.0).timeout
		if bank_a[0].is_ready() != 0 or bank_a[1].is_ready() != 0 or bank_a[2].is_ready() != 0 or\
		bank_a[3].is_ready() != 0 or  bank_a[4].is_ready() != 0 or bank_a[5].is_ready() != 0:
			push_warning("One or more Bank A channels still not ready. Delaying play again.")
			await get_tree().create_timer(3.0).timeout
		if bank_a[0].is_ready() != 0 or bank_a[1].is_ready() != 0 or bank_a[2].is_ready() != 0 or\
		bank_a[3].is_ready() != 0 or  bank_a[4].is_ready() != 0 or bank_a[5].is_ready() != 0:
			push_error("Bank A not fully ready. Abort.")
			return
		bank_a[0].start()
		bank_a[1].start()
		bank_a[2].start()
		bank_a[3].start()
		bank_a[4].start()
		bank_a[5].start()
		currently_playing = "A"
		started_playing.emit("A")
		print("Swapped over to A. Finished")
		finished_preparation = false
		return

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("move_left"):

		prepare_new_bank(
			["res://Assets/TestMusic/Daytime1.ogg", "res://Assets/TestMusic/Daytime2.ogg", "res://Assets/TestMusic/Daytime3.ogg",\
			"res://Assets/TestMusic/Daytime4.ogg","res://Assets/TestMusic/Daytime5.ogg","res://Assets/TestMusic/Daytime6.ogg"],
			[],
			[]
		)

	if Input.is_action_just_pressed("move_right"):

		prepare_new_bank(
			[ "res://Assets/TestMusic/MenuLayer1.ogg",  "res://Assets/TestMusic/MenuLayer2.ogg",  "res://Assets/TestMusic/MenuLayer3.ogg"],
			[],
			[true]
		)

	if Input.is_action_just_pressed("move_down"):
		prepare_new_bank(
			[ "res://Assets/TestMusic/The Golden City OST (1).ogg"],
			[],
			[true, 3.0]
		)

	if Input.is_action_just_pressed("comma"):
				play_immediately(
			["res://Assets/TestMusic/1-Up (1).ogg"],
			[],
			[false]
		)
		
	if Input.is_action_just_pressed("point"):
				play_immediately(
			["res://Assets/TestMusic/Rusty Ruins Zone 1.ogg", "res://Assets/TestMusic/Rusty Ruins Zone2.ogg"],
			[0.0, -80],
			[true]
		)

	if Input.is_action_just_pressed("move_up"):
		print("Received Switchoverplay")
		play_prepared_bank()
	
	var new_volume = 1
	if Input.is_action_pressed("move_fast"):
		new_volume = -80

	if Input.is_action_just_pressed("volume1"):
		print("Key received: ", new_volume)
		set_volume([0], [new_volume], [1])
		
	if Input.is_action_just_pressed("volume2"):
		set_volume([1], [new_volume], [1])
		
	if Input.is_action_just_pressed("volume3"):
		set_volume([2], [new_volume], [1])
		
	if Input.is_action_just_pressed("volume4"):
		set_volume([3], [new_volume], [1])
		
	if Input.is_action_just_pressed("volume5"):
		set_volume([4], [new_volume], [1])
		
	if Input.is_action_just_pressed("volume6"):
		set_volume([5], [new_volume], [1])
		
	if Input.is_action_just_pressed("swap_1"):
		set_volume([0, 1], [1 , -80], [0.5, 1])
		
	if Input.is_action_just_pressed("swap_2"):
		set_volume([0, 1], [-80 ,  1], [1, 0.5])
	
	if Input.is_action_just_pressed("Escape"):
		stop_bank()

func prepare_new_bank(files: Array, volumes: Array, loop_local: Array):
	if !(files is Array) or files.size() < 1:
		printerr("[dynamic_audio] Error: prepare_new_bank: files array missing or too small. At least 1 is required. bailing.")
		return
	if files is Array and files.size() > 6:
		printerr("[dynamic_audio] Error: prepare_new_bank: files array to big. only 6 tracks max. Bailing")
		return
	if volumes is Array and volumes.size() > 6:
		printerr("[dynamic_audio] Error: prepare_new_bank: volumes array too big. only 6 volume values are allowd. Bailing.")
		return
	if files is Array:
		for i in range(files.size()):
			next[i] = files[i]

	if volumes is Array:
		if volumes.size() > 0:
			for j in range(volumes.size()):
				starting_volume[j] = volumes[j]

	if loop_local is Array and loop_local.size() == 1:
		loop[0] = loop_local[0]
		loop[1] = null

	if loop_local is Array and loop_local.size() == 2:
		loop[0] = loop_local[0]
		loop[1] = loop_local[1]

	_prepare_play()


func play_prepared_bank() -> int:
	if !started_preparation and !finished_preparation:
		printerr("[dynamic_audio] Error: Attempting to play when no new Bank has been prepared.")
		return 1
	if started_preparation and !finished_preparation:
		printerr("[dynamic_audio] Warning: Attempting to play when Bank preparation hasn't completed. Trying again.")
		for n in 10:
			await get_tree().create_timer(1.0).timeout
			if started_preparation and !finished_preparation:
				push_warning("[dynamic_audio] Warning: Preparation still hasn't completed after ", n, " seconds.")
			if n == 10:
				push_error("[dynamic_audio] Error: Bailing: Preparation still not complete.")
				printerr("[dynamic_audio] Error: Bailing: Preparation still not complete.")
				return 1

	if !started_preparation and finished_preparation:
		_switchover_play()
		return 0
	return 1
	
	
func set_volume(channels: Array, volumes: Array, durations: Array):
	print("Entered into set_volume with: ", channels," ", volumes," ", durations)
	if channels is Array and volumes is Array and durations is Array:
		if channels.size() != volumes.size() and channels.size() != durations.size():
			push_error("Volumes and Durations must equal in amount to channels.")
			return
		if currently_playing== "A":
			for n in range(channels.size()):
				print("n: ", n)
				print("Setting volume to: Bank A Channel: ", channels[n], " to level :", volumes[n], " Duration: ", durations[n])
				bank_a[channels[n]].fade_volume(volumes[n], durations[n])
		if currently_playing == "B":
			for n in channels:
				print("n: ", n)
			for n in range(channels.size()):
				print("n: ", n)
				print("Setting volume to: Bank B Channel: ", channels[n], " to level :", volumes[n], " Duration: ", durations[n])
				bank_b[channels[n]].fade_volume(volumes[n], durations[n])

func stop_bank():
	for n in 6:
		bank_a[n].end()
	for n in 6:
		bank_b[n].end()

func play_immediately(files: Array, volumes: Array, loop_local: Array):
	prepare_new_bank(files, volumes, loop_local)
	while started_preparation and !finished_preparation:
		var waiting = true
	play_prepared_bank()
	
