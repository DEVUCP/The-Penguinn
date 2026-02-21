extends CanvasLayer

var game_ended = false
signal game_won
signal game_lost


func change_money_label(new) -> void:
	$Control/HBoxContainer/MoneyBox/Panel/Label.text = "Money: " + str(new) + ' / Goal: ' + str(EconomyManager.win_condition)

func change_rep_bar(new) -> void:
	$Control/HBoxContainer/ReputationBox/ProgressBar.value = new

func win_game() -> void:
	game_won.emit()
	end_game()

func lose_game() -> void:
	game_lost.emit()
	get_tree().change_scene_to_file("res://src/lose_game_screen.tscn")
	
	end_game()
	

func end_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control/HBoxContainer.visible = false
	game_ended = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart_game()

func restart_game() -> void:
	get_tree().change_scene_to_file("res://src/test_scene.tscn")
	game_ended = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
