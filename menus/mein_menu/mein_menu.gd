extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/Play.grab_focus();


func _on_play_pressed() -> void:
	TransitionServer.transition("res://levels/first/first.tscn");


func _on_settings_pressed() -> void:
	TransitionServer.transition("res://menus/settings/settings.tscn");


func _on_credits_pressed() -> void:
	TransitionServer.transition("res://menus/credits/credits.tscn");
