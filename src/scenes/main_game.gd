class_name MainGame extends Node

const CHARACTER_SCENE_UID: String = 'uid://dl2rclb50xt2d'
const TORCH_SCENE_UID:     String = 'uid://dowddt5rfu0tm'
const MAZE_SCENE_UID:      String = 'uid://dxx8qrh5r4343'

var character: Character = null
var _torch: Torch = null
var _current_level: BaseLevel = null

# Game world root notes
@onready var level_root:  Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EntityRoot

# UI root nodes
@onready var hud_root:        Control = %HudRoot
@onready var pause_root:      Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot
@onready var debug_root:      Control = %DebugRoot

func _ready() -> void:
	_init_character()
	_load_level(MAZE_SCENE_UID)
	character.died.connect(_on_character_died)

func _load_level(level_scene_uid: String) -> void:
	_deferred_load_level.call_deferred(level_scene_uid)
	
func _deferred_load_level(level_scene_uid: String) -> void:
	if _current_level != null:
		_current_level.queue_free()
		_current_level = null
		
	# Allow the old level to finish freeing before adding the new one
	await get_tree().process_frame
	
	var new_level: PackedScene = ResourceLoader.load(level_scene_uid)
	
	if new_level == null:
		push_error('Could not load level as packed scene: ' + level_scene_uid)
		return 
		# TODO: Make this fall back somewhere else
	
	_current_level = new_level.instantiate()
	if _current_level == null:
		push_error('Loaded level is not of type Level or does not exist')
		return 
		# TODO: Make this fall back somewhere else
	
	level_root.add_child(_current_level)
	
	# Allow level to fully process before accessing it
	await get_tree().process_frame
	
	_init_torch() # TODO: Figure out a nicer way to do this. This is cursed. 
	_place_torch_at_level_spawn()
	_place_character_at_level_spawn() 

func _init_character() -> void:
	var character_scene: PackedScene = ResourceLoader.load(CHARACTER_SCENE_UID)
	character = character_scene.instantiate()
	entity_root.add_child(character)

func _init_torch() -> void: 
	var torch_scene: PackedScene = ResourceLoader.load(TORCH_SCENE_UID)
	_torch = torch_scene.instantiate()
	entity_root.add_child(_torch)

func _place_character_at_level_spawn() -> void:
	if character == null:
		push_error('Cannot place character in level because the character is null')
		return 
		# TODO: Make this fall back somewhere else
	if _current_level == null:
		push_error('Cannot playece character in level because the current level is null')
		return 
		# TODO: Make this fall back somewhere else
	
	character.global_position = _current_level.get_default_character_spawn()

func _place_torch_at_level_spawn() -> void:
	if _torch == null:
		push_error('Cannot place torch in level because the torch is null')
		return 
		# TODO: Make this fall back somewhere else
	if _current_level == null:
		push_error('Cannot place torch in level because the current level is null')
		return 
		# TODO: Make this fall back somewhere else
	
	_torch.global_position = _current_level.get_default_torch_spawn()

func _on_character_died() -> void:
	_init_torch()
	_place_torch_at_level_spawn()
	_place_character_at_level_spawn()
