extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/Back.grab_focus();


func _on_back_pressed() -> void:
	TransitionServer.transition("res://menus/mein_menu/mein_menu.tscn");
