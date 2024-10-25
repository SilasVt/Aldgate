extends Node2D

@onready var BankA = [$BankA/BankA1, $BankA/BankA2, $BankA/BankA3, $BankA/BankA4, $BankA/BankA5, $BankA/BankA6]
@onready var BankB = [$BankB/BankB1, $BankB/BankB2, $BankB/BankB3, $BankB/BankB4, $BankB/BankB5, $BankB/BankB6]

var next = [ "", "", "", "", "", ""]
var currently_playing := "A"

func prepare_play():
	if currently_playing == "A":
		for n in 6:
			if next[n] != "":
				BankB[n].stream = load(next[n])
				next[n] = ""
		return
	
	if currently_playing == "B":
		for n in 6:
			if next[n] != "":
				BankA[n].stream = load(next[n])
		return
		
	else:
		print("dynamic_audio.gd Error: Wrong or undefined currently_playing string")
		
		
func switchover_play():
	if currently_playing == "A":
		for n in 6:
			BankB[n].set_volume(0)
			BankB[n].set_stopping(true)
		
		BankB[1].play
		BankB[2].play
		BankB[3].play
		BankB[4].play
		BankB[5].play
		BankB[6].play
		return
		
	if currently_playing == "B":
		for n in 6:
			BankA[n].set_volume(0)
			BankA[n].set_stopping(true)
		
		BankA[1].play
		BankA[2].play
		BankA[3].play
		BankA[4].play
		BankA[5].play
		BankA[6].play
		return
		
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
