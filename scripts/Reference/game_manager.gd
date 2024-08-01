extends Node
# REFERENCES
@onready var score_label = $score_label

# VARIABLES
var score = 0

# METHODS
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_points(amount):
	score += amount
	score_label.text = "Collected " + str(score) + " coins!";
