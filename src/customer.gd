extends Node3D




@onready var t_timer = $ToleranceTimer
var order = Order.new()
@export var tol_time = 10.0
@export var max_cash = 10.0
signal despawned_customer(customer)
var interactable = false


func _ready() -> void:
	t_timer.start(tol_time)
	order.generate_order_item()
	print(order.get_item())

func set_color(color) -> void:
	$MeshInstance3D.material_override.albedo_color = color

func take_order(item) -> void:
	print("THANK U TANK U")
	EconomyManager.add_cash(get_cash_from_formula())
	if order.is_order_correct(item):
		print("item correct!")
		EconomyManager.add_rep(1)
	else:
		print("item incorrect!")
		EconomyManager.reduce_rep(1)
	despawned_customer.emit(self)

func get_cash_from_formula() -> float:
	return max_cash * (t_timer.wait_time/tol_time)

func enable_interactability() -> void:
	interactable = true

func get_interactable() -> bool:
	return interactable


func _on_tolerance_timer_timeout() -> void:
	despawned_customer.emit(self)
	EconomyManager.reduce_rep(1)
