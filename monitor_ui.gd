extends CanvasLayer

@onready var message_label = $Control/ColorRect/RichTextLabel
@onready var accept_button = $Control/ColorRect/AcceptButton
@onready var reject_button = $Control/ColorRect/RejectButton

signal message_resolved(accepted: bool)

func _ready():
	self.visible = false
	accept_button.pressed.connect(_on_accept)
	reject_button.pressed.connect(_on_reject)

func show_message(message: String):
	message_label.text = message
	self.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_message():
	self.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_accept():
	message_resolved.emit(true)
	hide_message()

func _on_reject():
	message_resolved.emit(false)
	hide_message()
