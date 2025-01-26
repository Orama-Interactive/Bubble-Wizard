extends Node2D

@onready var arrow_keys_tutorial_label: Label = $ArrowKeysTutorialLabel
@onready var jump_tutorial_label: Label = $JumpTutorialLabel
@onready var jump_tutorial_label2: Label = $JumpTutorialLabel2


func _ready() -> void:
	var left_string := InputMap.action_get_events("left")[0].as_text().replace(" (Physical)", "")
	var right_string := InputMap.action_get_events("right")[0].as_text().replace(" (Physical)", "")
	var jump_string := InputMap.action_get_events("jump")[0].as_text().replace(" (Physical)", "")
	arrow_keys_tutorial_label.text = (
		tr(arrow_keys_tutorial_label.text) % [left_string, right_string]
	)
	jump_tutorial_label.text = tr(jump_tutorial_label.text) % [jump_string]
	jump_tutorial_label2.text = tr(jump_tutorial_label2.text) % [jump_string]
