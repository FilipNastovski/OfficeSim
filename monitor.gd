extends StaticBody3D

@onready var monitor = $Monitor_01_003_330
@onready var case_outline_mesh = $Monitor_01_003_330/Case/CaseMeshInstance3D
@onready var base_outline_mesh = $Monitor_01_003_330/Base/BaseMeshInstance3D
@onready var message_sound = $AudioStreamPlayer3D

var selected = false
var has_message = false
var pending_message: String = ""
var outline_width = 0.002

func _ready():
	get_tree().get_first_node_in_group("player").interact_object.connect(_set_selected)
	get_tree().root.find_child("MonitorUi", true, false).message_resolved.connect(_on_message_resolved)
	case_outline_mesh.visible = false
	base_outline_mesh.visible = false
	add_to_group("monitor")


func _process(delta: float):
	var show_outline = selected or has_message
	case_outline_mesh.visible = show_outline
	base_outline_mesh.visible = show_outline
	if selected:
		monitor.position.y = outline_width
	else:
		monitor.position.y = 0

func _set_selected(object):
	selected = self == object

func receive_message(message: String):
	has_message = true
	pending_message = message
	message_sound.play()

func _on_message_resolved(accepted: bool):
	has_message = false
	pending_message = ""
