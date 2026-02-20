extends Node3D

enum states{
	EMPTY,
	CHOCO,
	MILK_COLD,
	MILK_HOT,
	MARSHMELLOW,
}

var is_hot = false

var current_state = states.EMPTY

func get_current_state() -> int:
	return current_state

func discard_self():
	call_deferred("queue_free")

func add_ingredient(ingredient : String) -> void:
	match ingredient:
		"CHOCO":
			attempt_add_choco()
		"MILK_COLD":
			attempt_add_milk("cold")
		"MILK_HOT":
			attempt_add_milk("hot")
		"MARSHMELLOW":
			attempt_add_marshmellow()

func attempt_add_choco() -> void:
	if !current_state == states.EMPTY:
		return
	$blockbench_export/chocolates.visible = true
	current_state = states.CHOCO

func attempt_add_milk(temperature : String) -> void:
	if !current_state == states.CHOCO:
		return
	$blockbench_export/milk.visible = true
	if temperature == "cold":
		current_state = states.MILK_COLD
	else:
		current_state = states.MILK_HOT
		is_hot = true

func attempt_add_marshmellow() -> void:
	if !(current_state == states.MILK_COLD or current_state == states.MILK_HOT):
		return
	$blockbench_export/marshmellows.visible = true
	current_state = states.MARSHMELLOW
