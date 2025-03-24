extends Node

var durations = {}
var actions = {}
var jumps = {}

var was_down = true
var last_id = -1

var character_id = 1

var current_level = 1
var total_levels = 7

var is_changing_level = false
var level_text = ""

var level_texts = ["Good Job!", "Amazing!", "Great Job!", "Excellent!", "Well Done!", "Impressive!", "Brilliant!", "Keep Going!", "Outstanding!"]
