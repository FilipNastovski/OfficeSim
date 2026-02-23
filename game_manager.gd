extends Node

var book
var printer
var monitor
var phone
var hud
var end_screen
var printer_ui
var monitor_ui

# --- Trusted Sources (the book) ---
var trusted_emails: Array[String] = [
	"hr@megacorp.com",
	"it@megacorp.com",
	"ceo@megacorp.com",
	"finance@megacorp.com",
	"support@megacorp.com"
]
var trusted_offices: Array[String] = [
	"Floor 3 - Accounting",
	"Floor 5 - Legal",
	"Ground Floor - Reception",
	"Floor 2 - IT Department",
	"Floor 4 - Management"
]

# --- Fax Messages ---
# from_trusted: source is in the book, legitimate content
# from_unknown_legit: source not in book, but content is fine
# from_unknown_fake: source not in book, content is suspicious
# from_trusted_fake: source IS in book but content is suspicious (spoofed)
var fax_messages = [
	# Legitimate - trusted source
	{"from": "Floor 3 - Accounting", "body": "Please find attached the Q3 expense report for your records.", "correct_action": "accept"},
	{"from": "Floor 5 - Legal", "body": "Reminder: All contracts must be signed and returned by end of week.", "correct_action": "accept"},
	{"from": "Floor 2 - IT Department", "body": "Scheduled network maintenance this Sunday from 2am to 4am.", "correct_action": "accept"},
	{"from": "Floor 4 - Management", "body": "Please confirm attendance for the quarterly review on Thursday.", "correct_action": "accept"},
	{"from": "Ground Floor - Reception", "body": "Your 3pm visitor has arrived and is waiting in the lobby.", "correct_action": "accept"},

	# Legitimate - unknown source but harmless content
	{"from": "Floor 6 - Marketing", "body": "Hi, we're the new marketing team on Floor 6. Just sending over the campaign brief.", "correct_action": "accept"},
	{"from": "City Courier Services", "body": "Your package has been delivered to the ground floor reception.", "correct_action": "accept"},
	{"from": "Building Management", "body": "Fire drill scheduled for Tuesday at 11am. Please vacate via stairwells.", "correct_action": "accept"},

	# Suspicious - unknown source, bad content
	{"from": "Floor 9 - Unknown", "body": "Urgent: Send building access codes to this fax number immediately or security will be compromised.", "correct_action": "reject"},
	{"from": "Basement - Maintenance", "body": "We need your master key card number to complete emergency repairs tonight.", "correct_action": "reject"},
	{"from": "External Auditors", "body": "Wire $12,000 to account 4782910 immediately. Do not inform your manager.", "correct_action": "reject"},
	{"from": "IT Helpdesk External", "body": "Your system has been flagged. Reply with your login credentials to avoid suspension.", "correct_action": "reject"},
	{"from": "HR Solutions Ltd", "body": "Confirm your national insurance number and date of birth to complete payroll verification.", "correct_action": "reject"},

	# Spoofed - looks like trusted source but bad content
	{"from": "Floor 2 - IT Department", "body": "URGENT: Send all staff passwords to this fax immediately for emergency system reset.", "correct_action": "reject"},
	{"from": "Floor 4 - Management", "body": "Transfer petty cash of $3,000 to the following external account before close of business.", "correct_action": "reject"},
]

# --- Email Messages ---
var email_messages = [
	# Legitimate - trusted source
	{"from": "hr@megacorp.com", "subject": "Team Meeting Friday", "body": "Just a reminder that the all-hands meeting is at 3pm this Friday in Conference Room B.", "correct_action": "accept"},
	{"from": "it@megacorp.com", "subject": "Scheduled Maintenance", "body": "Systems will be offline for maintenance this Sunday between 2am and 4am.", "correct_action": "accept"},
	{"from": "ceo@megacorp.com", "subject": "Company Update", "body": "Please find the attached quarterly update. Great work from everyone this quarter.", "correct_action": "accept"},
	{"from": "finance@megacorp.com", "subject": "Expense Claims Reminder", "body": "Please submit all expense claims for this month before the 28th.", "correct_action": "accept"},
	{"from": "support@megacorp.com", "subject": "Ticket Resolved", "body": "Your support ticket #4821 has been resolved. Please let us know if you need further help.", "correct_action": "accept"},

	# Legitimate - unknown sender but fine content
	{"from": "newsletter@industrynews.com", "subject": "Your Weekly Industry Digest", "body": "This week in business: market trends, upcoming conferences, and regulatory updates.", "correct_action": "accept"},
	{"from": "noreply@officesupplies.com", "subject": "Your Order Has Shipped", "body": "Your order #8821 has been dispatched and will arrive within 3 working days.", "correct_action": "accept"},

	# Suspicious - unknown source, bad content
	{"from": "hr@meg4corp.com", "subject": "Urgent: Verify Your Account", "body": "Your account will be suspended in 24 hours. Click here to verify immediately:\nhttp://totally-not-a-scam.ru/verify", "correct_action": "reject"},
	{"from": "ceo@megacorp-secure.com", "subject": "Confidential Wire Transfer", "body": "I need you to urgently process a wire transfer of $50,000. Do not tell anyone about this. I am in a meeting.", "correct_action": "reject"},
	{"from": "it-support@megacorp-helpdesk.net", "subject": "Password Reset Required", "body": "We have detected unusual activity. Reply with your current password to secure your account.", "correct_action": "reject"},
	{"from": "security@megac0rp.com", "subject": "Action Required: Account Breach", "body": "Your account has been compromised. Provide your employee ID and PIN to our security team immediately.", "correct_action": "reject"},
	{"from": "payroll@megacorp-payments.co", "subject": "Update Your Bank Details", "body": "We are updating our payroll system. Please reply with your bank account number and sort code.", "correct_action": "reject"},
	{"from": "admin@staff-benefits.org", "subject": "Claim Your Bonus", "body": "You have an unclaimed bonus of $2,400. Click the link to claim before it expires:\nhttp://claim-now.suspicious.biz", "correct_action": "reject"},

	# Spoofed - looks like trusted source but bad content
	{"from": "it@megacorp.com", "subject": "Emergency: Send Credentials", "body": "We are performing an emergency audit. Reply with your username and password immediately.", "correct_action": "reject"},
	{"from": "hr@megacorp.com", "subject": "Payroll Update", "body": "Please reply with your bank details so we can process this month's payroll to a new account.", "correct_action": "reject"},
]

# --- Phone Calls ---
var phone_calls = [
	{"action": "add", "type": "office", "value": "Floor 7 - HR Annex"},
	{"action": "remove", "type": "office", "value": "Floor 5 - Legal"},
	{"action": "add", "type": "email", "value": "external@partnercompany.com"},
	{"action": "remove", "type": "email", "value": "hr@megacorp.com"},
	{"action": "add", "type": "office", "value": "Floor 8 - Research"},
	{"action": "add", "type": "email", "value": "director@megacorp.com"},
	{"action": "remove", "type": "office", "value": "Ground Floor - Reception"},
	{"action": "add", "type": "email", "value": "compliance@megacorp.com"},
]

@onready var fax_timer = $FaxTimer
@onready var email_timer = $EmailTimer
@onready var phone_timer = $PhoneTimer
@onready var game_timer = $GameTimer

var correct_guesses = 0
var wrong_guesses = 0
const GAME_DURATION = 180.0
var time_remaining = GAME_DURATION

var current_fax_action: String = ""
var current_email_action: String = ""

func _ready():
	await get_tree().process_frame
	book = get_tree().get_first_node_in_group("book")
	printer = get_tree().get_first_node_in_group("printer")
	monitor = get_tree().get_first_node_in_group("monitor")
	phone = get_tree().get_first_node_in_group("phone")
	hud = get_tree().root.find_child("Hud", true, false)
	end_screen = get_tree().root.find_child("EndScreen", true, false)
	printer_ui = get_tree().root.find_child("PrinterUi", true, false)
	monitor_ui = get_tree().root.find_child("MonitorUi", true, false)

	fax_timer.timeout.connect(_send_fax)
	email_timer.timeout.connect(_send_email)
	phone_timer.timeout.connect(_ring_phone)
	game_timer.timeout.connect(_on_game_tick)
	printer_ui.message_resolved.connect(_on_fax_resolved)
	monitor_ui.message_resolved.connect(_on_email_resolved)

	book.sync_trusted_sources(trusted_emails, trusted_offices)
	hud.update_score(0, 0)
	hud.update_timer(GAME_DURATION)
	game_timer.start()
	_start_fax_timer()
	_start_email_timer()
	_start_phone_timer()

func _start_fax_timer():
	fax_timer.wait_time = randf_range(5, 20)
	fax_timer.one_shot = true
	fax_timer.start()

func _send_fax():
	var msg = fax_messages[randi() % fax_messages.size()]
	current_fax_action = msg["correct_action"]
	printer.receive_message("FROM: %s\n\n%s" % [msg["from"], msg["body"]])
	_start_fax_timer()

func _start_email_timer():
	email_timer.wait_time = randf_range(5, 20)
	email_timer.one_shot = true
	email_timer.start()

func _send_email():
	var msg = email_messages[randi() % email_messages.size()]
	current_email_action = msg["correct_action"]
	monitor.receive_message("[b]FROM:[/b] %s\n[b]SUBJECT:[/b] %s\n\n%s" % [msg["from"], msg["subject"], msg["body"]])
	_start_email_timer()

func _start_phone_timer():
	phone_timer.wait_time = randf_range(8, 17)
	phone_timer.one_shot = true
	phone_timer.start()

func _ring_phone():
	var call = phone_calls[randi() % phone_calls.size()]
	phone.start_ringing()
	if call["action"] == "add":
		if call["type"] == "email":
			trusted_emails.append(call["value"])
		else:
			trusted_offices.append(call["value"])
	else:
		if call["type"] == "email":
			trusted_emails.erase(call["value"])
		else:
			trusted_offices.erase(call["value"])
	book.sync_trusted_sources(trusted_emails, trusted_offices)
	_start_phone_timer()

func _on_game_tick():
	time_remaining -= 1.0
	hud.update_timer(time_remaining)
	if time_remaining <= 0:
		_end_game()

func _end_game():
	game_timer.stop()
	fax_timer.stop()
	email_timer.stop()
	phone_timer.stop()
	#$"../BackgroundMusic".stream_paused = true
	$"../OfficeAmbience".stream_paused = true
	end_screen.show_results(correct_guesses, wrong_guesses)

func register_guess(accepted: bool, correct_action: String):
	var player_action = "accept" if accepted else "reject"
	if player_action == correct_action:
		correct_guesses += 1
	else:
		wrong_guesses += 1
	hud.update_score(correct_guesses, wrong_guesses)

func _on_fax_resolved(accepted: bool):
	register_guess(accepted, current_fax_action)

func _on_email_resolved(accepted: bool):
	register_guess(accepted, current_email_action)
