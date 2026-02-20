extends Node3D

var queue : Array = []
const MAX_AMOUNT = 4
var forward_amount = Vector3(0,0,-1)

func _ready() -> void:
	for i in range(0,MAX_AMOUNT):
		queue.append(0)

#func _process(delta: float) -> void:

func enqueue(item) -> void:
	queue[queue.size()-1] = item
	move_queue_along()

func move_queue_along() -> void:
	for i in range(queue.size()-1, 0, -1):
		if !queue[i-1] and queue[i]:
			print("should move",i, "into",i-1)
			queue[i-1] = queue[i]
			queue[i] = 0
			move_forward(queue[i-1])
			move_queue_along()
	if queue[0]:
		make_first_interactable()
	print(queue)


func make_first_interactable() -> void:
	var customer : Node3D = queue[0]
	customer.call_deferred("enable_interactability")

func move_forward(object : Node3D) -> void:
	object.translate(forward_amount)

func dequeue() -> void:
	queue[0] = 0
	move_queue_along()
	print("huh")

func is_full() -> bool:
	if !queue[queue.size()-1]:
		return false
	return true
