extends Area2D


export var dialog_name: String = "";


func _interact() -> void:
	var dialog = Dialogic.start(dialog_name);
	dialog.pause_mode = PAUSE_MODE_PROCESS;
	
	get_tree().paused = true;
	add_child(dialog);
	
	Global.allow_pause = false;
	yield(dialog, "timeline_end");
	Global.allow_pause = true;
	
	get_tree().paused = false;
