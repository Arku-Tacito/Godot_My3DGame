extends Label

var score = 0

func _ready():
	text = "Score: %s" % score

func _on_Mob_squashed():
	score += 1
	text = "Score: %s" % score
