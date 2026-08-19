extends Label

var time_passed;
var minutes;
var seconds;
var started = false;
# Called when the node enters the scene tree for the first time.
func start() -> void:
	time_passed = 0 
	minutes = 0
	seconds = 0
	started = true
	self.visible = true

func _ready():
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not started:
		return
	time_passed += delta
	
	minutes = int(time_passed) / 60
	seconds = int(time_passed) % 60
	self.text = "Timer: %02d:%02d" % [minutes, seconds]
