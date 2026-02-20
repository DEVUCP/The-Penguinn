class_name Order
extends Node

enum orders{
	EMPTY,
	CHOCO,
	MILK_COLD,
	MILK_HOT,
	MARSHMELLOW,
}

var item = orders.EMPTY

#func _ready() -> void:
	#_generate_order_item()
	#print(item)

func generate_order_item() -> void:
	item = randi_range(orders.MILK_COLD, orders.MARSHMELLOW) as orders

func is_order_correct(item_to_compare) -> bool:
	return item == item_to_compare

func get_item() -> int:
	return item
