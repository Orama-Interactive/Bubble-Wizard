extends Panel

@onready var grid_container: GridContainer = $CenterContainer/GridContainer


func _ready() -> void:
	var max_level: int = GameManager.config_file.get_value("progress", "max_level", 0)
	for i in GameManager.levels.size():
		var button := Button.new()
		button.text = tr("Level %s") % (i + 1)
		button.theme_type_variation = "UnchainedButton"
		button.disabled = max_level < i
		grid_container.add_child(button)
		if i == 0:
			button.grab_focus()
		button.pressed.connect(_on_level_button_pressed.bind(i))


func _on_level_button_pressed(level_index: int) -> void:
	GameManager.current_level_index = level_index
	GameManager.change_level()


func _on_return_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
