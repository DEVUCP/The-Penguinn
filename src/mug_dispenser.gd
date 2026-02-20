extends Node3D

var mug_node = preload("res://src/mug.tscn")

func give_new_mug() -> Node3D:
	var mug_instance = mug_node.instantiate()
	return mug_instance

func get_interactable() -> bool:
	return true
