extends Node2D

@onready var player: CharacterBody2D = $Player

var pickRight = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(player and player.get_score() > 150 and posmod(player.get_score(), 150) == 0 ):
		#spawn enemy avery 150 score
		var scene = preload("res://scenes/enemies/basic/BasicEnemy.tscn").instantiate()
		
		
		if(pickRight):
			scene.global_position = $Camera2D/SpawnPoint1.position
			#scene.set_global_pos($Camera2D/SpawnPoint1.global_position)
		else:
			scene.position =$Camera2D/SpawnPoint2.position
			#scene.set_global_pos($Camera2D/SpawnPoint2.global_position)
		add_child(scene)
		pickRight = !pickRight
