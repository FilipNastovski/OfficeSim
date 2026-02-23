extends StaticBody3D

@onready var phone = $phone
@onready var handle_outline_mesh = $phone/handle/HandleOutlineMeshInstance3D
@onready var base_outline_mesh   = $phone/base/BaseOutlineMeshInstance3D
@onready var ring_sound = $AudioStreamPlayer3D
@onready var answer_sound = $HangUpAudio

var selected = false
var is_ringing = false
var outline_width = 0.002

func _ready():
	get_tree().get_first_node_in_group("player").interact_object.connect(_set_selected)
	handle_outline_mesh.visible = false
	base_outline_mesh.visible = false
	add_to_group("phone")

func _process(delta: float):
	var show_outline = selected or is_ringing
	handle_outline_mesh.visible = show_outline
	base_outline_mesh.visible = show_outline
	if selected:
		phone.position.y = outline_width
	else:
		phone.position.y = 0

func _set_selected(object):
	selected = self == object

func start_ringing():
	is_ringing = true
	ring_sound.play()

func answer_phone():
	is_ringing = false
	ring_sound.stop()
	answer_sound.play()
