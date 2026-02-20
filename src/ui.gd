extends CanvasLayer

func change_money_label(new) -> void:
	$Control/HBoxContainer/MoneyBox/Panel/Label.text = "Money: " + str(new)

func change_rep_bar(new) -> void:
	$Control/HBoxContainer/ReputationBox/ProgressBar.value = new
