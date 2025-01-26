extends Node2D

@onready var bubble_form_tutorial_label: Label = $BubbleFormTutorialLabel


func _ready() -> void:
	var charge_str := InputMap.action_get_events("charge_bubble")[0].as_text().replace(
		" (Physical)", ""
	)
	var left_string := InputMap.action_get_events("left")[0].as_text().replace(" (Physical)", "")
	var right_string := InputMap.action_get_events("right")[0].as_text().replace(" (Physical)", "")
	var up_string := InputMap.action_get_events("up")[0].as_text().replace(" (Physical)", "")
	var down_string := InputMap.action_get_events("down")[0].as_text().replace(" (Physical)", "")
	bubble_form_tutorial_label.text = tr(bubble_form_tutorial_label.text) % [
		charge_str, up_string, left_string, down_string, right_string
	]
