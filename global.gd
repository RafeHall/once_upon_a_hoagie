extends Node


var settings: SettingsResource = null;
var player: Player = null;
var camera: Camera2D = null;

var allow_pause: bool = false;

var _settings: Node = null;


func _ready() -> void:
	var dir = Directory.new();
	if dir.file_exists("user://config.tres"):
		settings = load("user://config.tres");
	else:
		settings = SettingsResource.new();


func _enter_tree() -> void:
	get_tree().auto_accept_quit = false;
	
	pause_mode = Node.PAUSE_MODE_PROCESS;


func _exit_tree() -> void:
	ResourceSaver.save("user://config.tres", settings);


func _process(delta: float) -> void:
	if not allow_pause:
		return;
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused;
		
		if get_tree().paused:
			_settings = preload("res://menus/settings/settings.tscn").instance();
			
			get_tree().root.add_child(_settings);
		else:
			if _settings != null:
				_settings.queue_free();


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().call_deferred("quit");
