extends Node2D


func _enter_tree() -> void:
	Global.allow_pause = true;


func _exit_tree() -> void:
	Global.allow_pause = false;
