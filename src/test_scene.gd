extends Node3D
func _ready():
	Ui.game_won.connect(_on_game_won)
	Ui.game_lost.connect(_on_game_lost)

func _on_game_won():
	self.call_deferred("queue_free")
	print("game won")

func _on_game_lost():
	queue_free()
	self.call_deferred("queue_free")
	print("game lost")
