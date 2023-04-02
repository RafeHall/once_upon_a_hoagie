extends StaticBody2D


export var lifetime: float = 1.25;


func _enter_tree() -> void:
	yield(get_tree().create_timer(lifetime), "timeout");
	
	queue_free();


func get_class() -> String:
	return "platform";
