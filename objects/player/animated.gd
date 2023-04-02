extends Node2D


var speed: float = 0.0;


func _process(delta: float) -> void:
	$AnimationPlayer.playback_speed = speed;


func _visibility_changed() -> void:
	$AnimationPlayer.play("Moving");
