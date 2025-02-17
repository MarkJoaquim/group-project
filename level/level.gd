extends Node2D

@onready var playerSpawner := $PlayerSpawner as Node2D
@onready var enemySpawnpoints := $EnemySpawnpoints as Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.spawn(playerSpawner)
	enemySpawnpoints.get_children().all(Enemy.spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
