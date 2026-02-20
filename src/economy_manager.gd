extends Node

var cash = 0
var rep = 5

func remove_cash(decr) -> void:
	set_cash(cash - decr)

func add_cash(add) -> void:
	set_cash(cash + add)

func set_cash(new_amount) -> void:
	cash = new_amount
	Ui.change_money_label(new_amount)

func reduce_rep(decr) -> void:
	set_rep(rep - decr)
	# TODO: Add check if zero then call game end

func add_rep(add) -> void:
	set_rep(rep + add)

func set_rep(new_amount) -> void:
	rep = new_amount
	Ui.change_rep_bar(new_amount)
