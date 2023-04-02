class_name SettingsResource
extends Resource


export var master_volume: float = 0.5 setget _set_master_volume;
export var music_volume: float = 0.5 setget _set_music_volume;
export var effects_volume: float = 0.5 setget _set_effects_volume;
export var dialog_volume: float = 0.5 setget _set_dialog_volume;

export var fullscreen: bool = false setget _set_fullscreen;


func _set_master_volume(volume: float) -> void:
	master_volume = volume;
	
	var effects_bus = AudioServer.get_bus_index("Master");
	AudioServer.set_bus_volume_db(effects_bus, linear2db(volume));


func _set_music_volume(volume: float) -> void:
	music_volume = volume;
	
	var effects_bus = AudioServer.get_bus_index("Music");
	AudioServer.set_bus_volume_db(effects_bus, linear2db(volume));


func _set_effects_volume(volume: float) -> void:
	effects_volume = volume;
	
	var effects_bus = AudioServer.get_bus_index("Effects");
	AudioServer.set_bus_volume_db(effects_bus, linear2db(volume));


func _set_dialog_volume(volume: float) -> void:
	dialog_volume = volume;
	
	var dialog_bus = AudioServer.get_bus_index("Dialog");
	AudioServer.set_bus_volume_db(dialog_bus, linear2db(volume));


func _set_fullscreen(_fullscreen: bool) -> void:
	fullscreen = _fullscreen;
	
	OS.window_fullscreen = fullscreen;
