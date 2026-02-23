extends StaticBody3D

@onready var book = $BookNode3D
@onready var top_outline_mesh = $BookNode3D/Top/MeshInstance3D
@onready var bottom_outline_mesh = $BookNode3D/Bottom/MeshInstance3D
@onready var book_ui = get_tree().root.find_child("BookUi", true, false)

var selected = false
var outline_width = 0.002

func _ready():
	get_tree().get_first_node_in_group("player").interact_object.connect(_set_selected)
	top_outline_mesh.visible = false
	bottom_outline_mesh.visible = false
	add_to_group("book")

func _process(delta: float):
	top_outline_mesh.visible = selected
	bottom_outline_mesh.visible = selected

	if selected:
		book.position.y = outline_width
	else:
		book.position.y = 0

func _set_selected(object):
	selected = self == object

func sync_trusted_sources(emails: Array[String], offices: Array[String]):
	book_ui.approved_list.clear()
	for e in emails:
		book_ui.approved_list.append("EMAIL: " + e)
	for o in offices:
		book_ui.approved_list.append("OFFICE: " + o)
	book_ui.update_text()
