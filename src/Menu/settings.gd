extends Panel

@onready var languages: VBoxContainer = $MarginContainer/VBoxContainer/Languages
@onready var master_volume_slider: ValueSlider = %MasterVolumeSlider
@onready var music_volume_slider: ValueSlider = %MusicVolumeSlider
@onready var sounds_volume_slider: ValueSlider = %SoundsVolumeSlider


func _ready() -> void:
	var current_locale := TranslationServer.get_locale()
	var loaded_locales := TranslationServer.get_loaded_locales()
	var language_button_group := ButtonGroup.new()
#	loaded_locales.sort()
	for locale in loaded_locales:
		var check_box := CheckBox.new()
		check_box.button_group = language_button_group
		check_box.name = TranslationServer.get_locale_name(locale)
		check_box.text = check_box.name
		if locale == current_locale or locale + "_" in current_locale:
			check_box.button_pressed = true
		check_box.pressed.connect(_on_language_pressed.bind(locale))
		languages.add_child(check_box)
	if not is_instance_valid(language_button_group.get_pressed_button()):
		var check_box := languages.get_node("English") as CheckBox
		check_box.button_pressed = true

	master_volume_slider.grab_focus()
	master_volume_slider.value = (
		db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
	)
	music_volume_slider.value = (
		db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) * 100
	)
	sounds_volume_slider.value = (
		db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sounds"))) * 100
	)


func _on_language_pressed(locale: String) -> void:
	TranslationServer.set_locale(locale)


func _on_volume_slider_value_changed(value: float, bus: StringName) -> void:
	var bus_index := AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value / 100.0))


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/controls.tscn")


func _on_return_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
