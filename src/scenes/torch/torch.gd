class_name Torch extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('character'):
		var character: Character = body
		character.start_torch()
		queue_free()
