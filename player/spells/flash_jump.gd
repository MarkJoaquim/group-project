class_name FlashJump extends Node2D

const SCENE = preload("res://player/spells/flashJump.tscn")

@onready var animationPlayer := $AnimationPlayer as AnimationPlayer
@onready var sprite := $Sprite2D as Sprite2D

static func cast(player: Player) -> FlashJump:
	var new_cast := SCENE.instantiate() as FlashJump
	new_cast.position = player.position
	new_cast.scale = player.bodySprite.scale
	new_cast.set_as_top_level(true)
	new_cast.z_index = player.z_index - 1
	player.add_child(new_cast)
	return new_cast

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationPlayer.play("cast")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
