extends CanvasLayer

@onready var correct_label = $HBoxContainer/VBoxContainer/CorrectLabel
@onready var wrong_label = $HBoxContainer/VBoxContainer/WrongLabel
@onready var timer_label = $TimerLabel

func _ready():
	$HBoxContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	correct_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrong_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	timer_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

func update_score(correct: int, wrong: int):
	correct_label.text = "Correct: %d" % correct
	wrong_label.text = "Wrong: %d" % wrong

func update_timer(seconds_left: float):
	var minutes = int(seconds_left) / 60
	var seconds = int(seconds_left) % 60
	timer_label.text = "%d:%02d" % [minutes, seconds]
