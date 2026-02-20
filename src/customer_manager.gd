extends Node3D

var customer_budget = 7
@onready var queue = $Queue
@onready var spawn_timer = $SpawnTimer
var customer_node = preload("res://src/customer.tscn")
signal customer_despawned(customer)

func _ready() -> void:
	pass

func _eneque_new_customer(customer : Node3D) -> void:
	queue.add_child(customer)
	customer.despawned_customer.connect(_on_customer_despawned)
	customer.position = queue.position
	if customer_budget % 4 == 0:
		customer.set_color(Color.RED)
	elif customer_budget % 3:
		customer.set_color(Color.BLUE)
	else:
		customer.set_color(Color.PINK)
	queue.call_deferred("enqueue", customer)
	customer_budget-=1

func _on_customer_despawned(customer : Node3D) -> void:
	queue.dequeue()
	queue.remove_child(customer)
	customer.call_deferred("queue_free")

func _get_random_spawn_time() -> float:
	return randf_range(1,2)


func _on_spawn_timer_timeout() -> void:
	attempt_spawn_new_customer()
	spawn_timer.start(_get_random_spawn_time())

func attempt_spawn_new_customer() -> void:
	if !customer_budget or queue.is_full():
		return
	var new_customer = customer_node.instantiate()
	_eneque_new_customer(new_customer)
