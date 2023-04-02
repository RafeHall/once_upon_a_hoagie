extends Area2D


export var scene: PackedScene = null;



func _on_player_enter(body: Node) -> void:
	if not body is Player:
		return;
	
	if scene != null:
		TransitionServer.transition(scene.resource_path);
