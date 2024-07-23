extends Node2D
class_name ElementComponent

@export_enum("FIRE", "WATER", "EARTH", "WIND") var element: String
# Called when the node enters the scene tree for the first time.

func get_element():
	return element
