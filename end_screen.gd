extends CanvasLayer

@onready var result_label = $ColorRect/VBoxContainer/ResultLabel
@onready var tip_label = $ColorRect/VBoxContainer/TipLabel
@onready var quit_button = $ColorRect/VBoxContainer/HBoxContainer/QuitButton
@onready var restart_button = $ColorRect/VBoxContainer/HBoxContainer/ResetButton

var tips = [
	"Never click links in emails you weren't expecting.",
	"Check the sender's email address carefully — one letter can make it fake.",
	"Legitimate companies will never ask for your password over email.",
	"When in doubt, pick up the phone and verify with the sender directly.",
	"Fax headers can be spoofed — always verify the sending office.",
	"Urgency is a red flag. Scammers want you to act before you think.",
	"If a CEO emails asking for a secret wire transfer, it's almost certainly a scam.",
	"Hover over links before clicking — the real URL often reveals the trick.",
	"A misspelled domain like 'megac0rp.com' is a classic phishing technique.",
	"Legitimate IT departments will never ask for your credentials over email.",
	"When an offer seems too good to be true, it always is.",
	"Phishing attacks often impersonate people you trust — always verify unusual requests.",
	"Never send sensitive information over fax without confirming the recipient's number first.",
	"Scammers create fake urgency to stop you from thinking clearly.",
	"A real bank will never ask you to confirm your account details via email.",
	"Check for small spelling mistakes in company names — they're easy to miss.",
	"If someone asks you to keep a request secret from your manager, that's a major red flag.",
	"Email display names can be faked — always check the actual address behind them.",
	"Cybercriminals research their targets — a personalised email is not proof it's legitimate.",
	"Two factor authentication stops most account breaches even if your password is stolen.",
	"When in doubt, do nothing and escalate to a supervisor.",
	"Attachments from unknown senders can contain malware even if they look like normal documents.",
	"Scammers often pose as IT support to gain access to systems.",
	"A sense of panic in a message is usually manufactured — slow down and think.",
	"Regularly updating passwords reduces the damage caused by data breaches.",
]

func _ready():
	self.visible = false
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect/VBoxContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect/VBoxContainer/ResultLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect/VBoxContainer/TipLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	quit_button.pressed.connect(func(): get_tree().quit())
	restart_button.pressed.connect(func(): get_tree().reload_current_scene())

func show_results(correct: int, wrong: int):
	self.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	result_label.text = "Time is up!\n\n Correct: %d\n Wrong: %d" % [correct, wrong]
	tip_label.text = "Tip: " + tips[randi() % tips.size()]
