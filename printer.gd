extends StaticBody3D

@onready var printer_ui = get_tree().root.find_child("PrinterUi", true, false)
@onready var fax_sound = $AudioStreamPlayer3D


@onready var outline_mesh_1 = $printer_001_14/Case/CaseMeshInstance3D

var selected = false
var has_message = false
var pending_message: String = ""
var outline_width = 0.002

func _ready():
	get_tree().get_first_node_in_group("player").interact_object.connect(_set_selected)
	printer_ui.message_resolved.connect(_on_message_resolved)
	add_to_group("printer")
	outline_mesh_1.visible = false

func _process(delta: float):
	outline_mesh_1.visible = selected or has_message
	if selected:
		outline_mesh_1.position.y = outline_width
	else:
		outline_mesh_1.position.y = 0

func _set_selected(object):
	selected = self == object

func receive_message(message: String):
	has_message = true
	pending_message = message
	fax_sound.play()

func _on_message_resolved(accepted: bool):
	has_message = false
	pending_message = ""
