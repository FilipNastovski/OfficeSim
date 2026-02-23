extends CharacterBody3D

signal interact_object

@onready var camera_3d = $Camera3D
@onready var ray_cast_3d = $Camera3D/RayCast3D
@onready var crosshair = $Camera3D/Crosshair
@onready var book_ui = get_tree().root.find_child("BookUi", true, false)
@onready var printer_ui = get_tree().root.find_child("PrinterUi", true, false)
@onready var monitor_ui = get_tree().root.find_child("MonitorUi", true, false)

const MONITOR_FOV = 60.0  # Zoomed in, tweak to taste
var original_fov: float

var is_reading = false
var is_reading_fax = false
var is_at_monitor = false

var original_position: Vector3
var original_rotation: Vector3

const CAMERA_SENS = 0.003
const MONITOR_DROP = 0.67

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	add_to_group("player")
	original_fov = camera_3d.fov
	original_position = position
	original_rotation = rotation
	printer_ui.message_resolved.connect(_on_printer_resolved)
	monitor_ui.message_resolved.connect(_on_monitor_resolved)

func _input(event):
	if event.is_action_pressed("quit"): get_tree().quit()
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("release_cursor"):
		if is_at_monitor:
			suspend_monitor()
		elif is_reading_fax:
			suspend_printer()
		elif is_reading:
			close_book()

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and not is_reading:
		rotation.y -= event.relative.x * CAMERA_SENS
		rotation.x -= event.relative.y * CAMERA_SENS
		rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(20))

func _process(delta: float):
	if is_reading: return
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		interact_object.emit(collider)
		if Input.is_action_just_pressed("click") and collider.has_method("_set_selected"):
			if collider.name == "Book":
				open_book()
			elif collider.name == "Printer" and collider.has_message:
				open_printer(collider)
			elif collider.name == "Monitor" and collider.has_message:
				open_monitor(collider)
			elif collider.name == "Phone" and collider.is_ringing:
				collider.answer_phone()
	else:
		interact_object.emit(null)

func _physics_process(delta):
	move_and_slide()

# --- Book ---
func open_book():
	is_reading = true
	crosshair.visible = false
	book_ui.toggle_book(true)

func close_book():
	is_reading = false
	crosshair.visible = true
	book_ui.toggle_book(false)

# --- Printer ---
func open_printer(printer_node):
	is_reading = true
	is_reading_fax = true
	crosshair.visible = false
	printer_ui.show_message(printer_node.pending_message)

func close_printer():
	is_reading = false
	is_reading_fax = false
	crosshair.visible = true

func _on_printer_resolved(accepted: bool):
	close_printer()

# --- Monitor ---
func open_monitor(monitor_node):
	is_reading = true
	is_at_monitor = true
	crosshair.visible = false
	position.y = original_position.y - MONITOR_DROP
	rotation.x = -0.02
	rotation.y = 1.5 # Tweak this to face your monitor squarely
	monitor_ui.show_message(monitor_node.pending_message)
	camera_3d.fov = MONITOR_FOV

func close_monitor():
	is_reading = false
	is_at_monitor = false
	crosshair.visible = true
	position = original_position
	rotation = original_rotation
	monitor_ui.hide_message()
	camera_3d.fov = original_fov

func _on_monitor_resolved(accepted: bool):
	close_monitor()
	
func suspend_monitor():
	is_reading = false
	is_at_monitor = false
	crosshair.visible = true
	position = original_position
	rotation = original_rotation
	camera_3d.fov = original_fov
	monitor_ui.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func suspend_printer():
	is_reading = false
	is_reading_fax = false
	crosshair.visible = true
	printer_ui.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
