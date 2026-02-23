extends CanvasLayer

@onready var label = $Control/ColorRect/RichTextLabel

var approved_list: Array[String] = []

func _ready():
	update_text()

func toggle_book(show: bool):
	self.visible = show
	if show:
		update_text()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func update_text():
	var full_text = "TRUSTED SOURCES:\n\n"
	for name in approved_list:
		full_text += "- " + name + "\n"
	label.text = full_text

func add_name(new_name: String):
	approved_list.append(new_name)
	update_text()
