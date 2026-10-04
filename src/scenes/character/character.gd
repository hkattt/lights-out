class_name Character extends CharacterBody2D

signal died

@onready var torch: PointLight2D = %Torch

# A dictionary that maps input map actions to direction vectors
const inputs = {
	"move_right": Vector2.RIGHT,
	"move_left":  Vector2.LEFT,
	"move_down":  Vector2.DOWN,
	"move_up":    Vector2.UP
}

# Stores the grid size, which is 16 (same as one tile)
var grid_size = 16

# Reference to the RayCast2D node
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _ready() -> void:
	torch.hide()

# Calls the move function with the appropriate input key
# if any input map action is triggered
func _unhandled_input(event):
	for action in inputs.keys():
		if event.is_action_pressed(action):
			_move(action)

# Updates the direction of the RayCast2D according to the input key
# and moves one grid if no collision is detected
func _move(action):
	var destination = inputs[action] * grid_size
	ray_cast_2d.target_position = destination
	ray_cast_2d.force_raycast_update()
	if not ray_cast_2d.is_colliding():
		position += destination

func start_torch() -> void:
	torch.show()
	var tween: Tween = create_tween()
	tween.tween_property(torch, "texture_scale", 0.2, 150.0)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished() -> void:
	died.emit()
	torch.hide()
	torch.texture_scale = 1.0
