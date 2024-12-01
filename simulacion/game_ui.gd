extends Control

@onready var score_label = $Score

var score = 0
var frames = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frames += 1
	score = frames / 120
	score_label.text = "Puntaje: %d" % score
