extends Node


onready var master_volume: HSlider = $"%Master";
onready var music_volume: HSlider = $"%Music";
onready var effects_volume: HSlider = $"%Effects";
onready var dialog_volume: HSlider = $"%Dialog";
onready var fullscreen: CheckBox = $"%Fullscreen";


func _ready() -> void:
	master_volume.value = Global.settings.master_volume;
	music_volume.value = Global.settings.music_volume;
	effects_volume.value = Global.settings.effects_volume;
	dialog_volume.value = Global.settings.dialog_volume;
	fullscreen.pressed = Global.settings.fullscreen;
	
	master_volume.grab_focus();


func _on_back_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false;
		Global._settings = null;
		queue_free();
	else:
		TransitionServer.transition("res://menus/mein_menu/mein_menu.tscn");
		


func _on_master_changed(value: float) -> void:
	Global.settings.master_volume = value;


func _on_music_changed(value: float) -> void:
	Global.settings.music_volume = value;


func _on_effects_changed(value: float) -> void:
	Global.settings.effects_volume = value;


func _on_dialog_changed(value: float) -> void:
	Global.settings.dialog_volume = value;


func _on_fullscreen_toggled(button_pressed: bool) -> void:
	Global.settings.fullscreen = button_pressed;


