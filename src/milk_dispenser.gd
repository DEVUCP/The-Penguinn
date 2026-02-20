extends Node3D

const hot_center = Vector3(-0.19,0.056,-0.19)
const cold_center = Vector3(0.19,0.056,-0.19)

@onready var cold_timer = $ColdTimer
@onready var hot_timer = $HotTimer
@export var cold_time = 2.0
@export var hot_time = 12.0
@onready var cold_mug = $ColdMug
@onready var hot_mug = $HotMug

var interactable = false

func get_interactable() -> bool:
	return interactable

func get_center(temp : String) -> Vector3:
	if temp == "cold":
		return cold_center
	return hot_center

func attempt_take_cold_drink(mug : Node3D) -> void:
	if !cold_mug.get_child_count():
		return
	take_mug(mug, cold_mug)

func attempt_take_hot_drink(mug : Node3D) -> void:
	if !hot_mug.get_child_count():
		return
	take_mug(mug, hot_mug)


func take_mug(mug : Node3D, temp_side) -> void:
	mug.get_parent().remove_child(mug)
	mug.position = Vector3.ZERO
	temp_side.add_child(mug)

func attempt_take_mug(mug : Node3D, temp : String) -> void:
	if temp == "cold":
		attempt_take_cold_drink(mug)
		return
	attempt_take_hot_drink(mug)
