extends Panel

@onready var player_animated_sprite_2d: AnimatedSprite2D = $PlayerAnimatedSprite2D


func _ready() -> void:
	player_animated_sprite_2d.play(&"default")
	GameManager.audio_stream_player.play()


func _on_play_button_pressed() -> void:
	var music_stream := (GameManager.audio_stream_player.get_stream_playback() as AudioStreamPlaybackInteractive)
	music_stream.switch_to_clip_by_name(&"Game")
	get_tree().change_scene_to_file("res://src/Levels/level_1.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/settings.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
