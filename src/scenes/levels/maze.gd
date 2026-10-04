class_name TestLevel extends BaseLevel

@onready var character_spawn: Node2D = %CharacterSpawn

func get_default_character_spawn() -> Vector2:
	return character_spawn.global_position
