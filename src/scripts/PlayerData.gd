extends Node

signal score_updated
signal player_died
signal combo_updated

var score:= 0 setget set_score
var deaths:= 0 setget set_deaths
var highest_combo:= 0 setget set_highest_combo
var combo_count:= 0 setget set_combo_count, get_combo_count

func reset():
	score = 0
	deaths = 0

func set_score(value: int):
	score = value
	emit_signal("score_updated")

func set_deaths(value: int):
	deaths = value
	emit_signal("player_died")	

func set_combo_count(value: int):
	combo_count = value
	emit_signal("combo_updated")

func get_combo_count() -> int:
	return combo_count

func set_highest_combo(value:int):
	highest_combo = value
