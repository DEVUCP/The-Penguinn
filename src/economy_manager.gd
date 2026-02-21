extends Node

var cash = 0
var rep = 5
const win_condition = 100 # cash
const lose_condition  = 0 # rep

func remove_cash(decr) -> void:
	set_cash(cash - decr)

func add_cash(add) -> void:
	set_cash(cash + add)
	if is_win_condition():
		Ui.win_game()

func set_cash(new_amount) -> void:
	cash = new_amount
	Ui.change_money_label(new_amount)

func reduce_rep(decr) -> void:
	set_rep(rep - decr)
	if is_lose_condition():
		Ui.lose_game()

func add_rep(add) -> void:
	set_rep(rep + add)

func set_rep(new_amount) -> void:
	rep = new_amount
	Ui.change_rep_bar(new_amount)

func is_win_condition() -> bool:
	return cash >= win_condition

func is_lose_condition() -> bool:
	return rep <= lose_condition
