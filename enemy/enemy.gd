class_name Enemy extends CharacterBody2D
const SCENE = preload("res://enemy/Enemy.tscn")

signal killed

@onready var platform_detector_left := $PlatformDetectorLeft as RayCast2D
@onready var platform_detector_right := $PlatformDetectorRight as RayCast2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var action_timer := $ActionTimer as Timer

const SPEED = 50.0
const TERMINAL_VELOCITY = 600
enum state {
	IDLE,
	BLINK,
	WALK
}

var _state = state.IDLE
var spawner: Node2D

static func spawn(spawnPoint: Node2D) -> Enemy:
	var enemy := SCENE.instantiate() as Enemy
	enemy.global_position = spawnPoint.global_position
	enemy.set_as_top_level(true)
	spawnPoint.add_child(enemy)
	enemy.spawner = spawnPoint
	enemy.action_timer.start()
	return enemy

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = minf(TERMINAL_VELOCITY, velocity.y + get_gravity().y * delta)

	if _state == state.IDLE or _state == state.BLINK:
		velocity.x = 0
	elif _state == state.WALK and velocity.is_zero_approx():
		velocity.x = SPEED * (1 if randf() > 0.5 else -1)
	elif _state == state.WALK:
		if not platform_detector_left.is_colliding():
			velocity.x = SPEED
		elif not platform_detector_right.is_colliding():
			velocity.x = -SPEED

	move_and_slide()
	
	if velocity.x > 0.0:
		sprite.scale.x = 1
	elif velocity.x < 0.0:
		sprite.scale.x = -1

	var animation := get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)

func playerKill() -> void:
	killed.emit()
	destroy()

func destroy() -> void:
	spawner.remove_child(self)
	queue_free()

func randomizeState() -> void:
	var stateNumber = randi_range(0, 2)
	if stateNumber == 0:
		_state = state.IDLE
	elif stateNumber == 1:
		_state = state.BLINK
	else:
		_state = state.WALK

func get_new_animation() -> StringName:
	if _state == state.WALK:
		return "walk"
	elif _state == state.BLINK:
		return "blink"
	else:
		return "idle"


func _on_action_timer_timeout() -> void:
	print_debug("timer timeout", _state)
	randomizeState()
	action_timer.start()
