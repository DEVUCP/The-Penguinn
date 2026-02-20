extends Node3D



@onready var hot_timer = $HotTimer
@onready var holder = $Holder
@export var hot_time = 2.0

var interactable = true

func get_interactable() -> bool:
	return interactable

func take_mug(mug : Node3D) -> void:
	interactable = false
	mug.get_parent().remove_child(mug)
	mug.position = Vector3.ZERO
	mug.rotation_degrees = Vector3.ZERO
	holder.add_child(mug)

func attempt_dispense(mug) -> void:
	attempt_take_mug(mug)

func attempt_take_mug(mug : Node3D) -> void:
	if holder.get_child_count():
		printerr("Mug already on")
		return
	if mug.get_current_state() != mug.states.CHOCO:
		printerr("Put chocolate first")
		return
	take_mug(mug)
	start_dispensing()

func start_dispensing() -> void:
	hot_timer.start(hot_time)
	# TODO: PLAY SOUND AND ANIMATION HERE


func _on_hot_timer_timeout() -> void:
	interactable = true
	var mug = holder.get_child(0)
	mug.add_ingredient("MILK_HOT")
	print("HOT DRINK FINISHED DISPENSING")

func attempt_give_finished_drink() -> Node3D:
	if !hot_timer.is_stopped():
		printerr("Drink still dispensing, cant take yet")
		return
	if !holder.get_child_count():
		printerr("No drink to take")
	var detached_mug = holder.get_child(0)
	holder.remove_child(detached_mug)
	return detached_mug
