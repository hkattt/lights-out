class_name LightsOut extends Control

signal retry_game

func _on_retry_button_pressed() -> void:
	retry_game.emit()
