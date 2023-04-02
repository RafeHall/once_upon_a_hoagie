extends Node


func transition(to: String) -> void:
	Global.camera = null;
	Global.player = null;
	
	var current_scene = get_tree().current_scene;
	var transition = preload("res://menus/transition/transition.tscn").instance();
	
	get_tree().root.add_child(transition);
	
	pause_mode = Node.PAUSE_MODE_PROCESS;
	transition.pause_mode = Node.PAUSE_MODE_PROCESS;
	
	transition.play();
	
	get_tree().paused = true;
	yield(transition, "finished");
	
	get_tree().change_scene(to);
	
	transition.reversed = true;
	transition.play();
	
	yield(transition, "finished");
	
	transition.queue_free();
	get_tree().paused = false;
	
