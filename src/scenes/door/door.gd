class_name Door extends Area2D

signal escaped_maze

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('character'):
		escaped_maze.emit()
