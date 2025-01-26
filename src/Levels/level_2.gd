extends Node2D

@onready var bubble_form_tutorial_label: Label = $BubbleFormTutorialLabel


func _ready() -> void:
	var charge_str := InputMap.action_get_events("charge_bubble")[0].as_text().replace(
		" (Physical)", ""
	)
	bubble_form_tutorial_label.text = tr(bubble_form_tutorial_label.text) % charge_str
