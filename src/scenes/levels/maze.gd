class_name TestLevel extends BaseLevel

@onready var character_spawn: Node2D = %CharacterSpawn
@onready var torch_spawn:     Node2D = %TorchSpawn
@onready var door_spawn:      Node2D = %DoorSpawn

func get_default_character_spawn() -> Vector2:
	return character_spawn.global_position

func get_default_torch_spawn() -> Vector2:
	return torch_spawn.global_position

func get_default_door_spawn() -> Vector2:
	return door_spawn.global_position
