class_name TestLevel extends BaseLevel

@onready var character_spawn: Node2D = %CharacterSpawn
@onready var torch_spawn: Node2D     = %TorchSpawn

func get_default_character_spawn() -> Vector2:
	return character_spawn.global_position

func get_default_torch_spawn() -> Vector2:
	return torch_spawn.global_position
