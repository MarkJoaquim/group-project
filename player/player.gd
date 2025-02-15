extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const TERMINAL_VELOCITY = 600


@onready var playerAnimation := $playerAnimation as AnimationPlayer
@onready var bodySprite := $body as Sprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y = minf(TERMINAL_VELOCITY, velocity.y + get_gravity().y * delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("jump") and velocity.y < 0.0:
		# The player let go of jump early, reduce vertical momentum.
		velocity.y *= 0.6

	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			bodySprite.scale.x = 1.0
		else:
			bodySprite.scale.x = -1.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	var animation := get_new_animation()
	if animation != playerAnimation.current_animation:
		playerAnimation.play(animation)

func get_new_animation() -> String:
	var animation_new: String
	if is_on_floor():
		if absf(velocity.x) > 0.1:
			animation_new = "run"
		elif Input.is_action_pressed("crouch"):
			animation_new = "duck"
		else:
			animation_new = "idle"
	else:
		animation_new = "jump"
	return animation_new
