tool
extends Node

var click_sound = preload("res://audio/click.wav");

var _cache: Dictionary = {};


func _enter_tree() -> void:
	cache_sound(click_sound, 1.0);


func play_sound(sample: AudioStreamSample, begin: float, end: float, pitch: float) -> void:
	if Engine.editor_hint:
		return;
	
	var player = AudioStreamPlayer.new();
	add_child(player);
	
	player.bus = "Effects";
	player.stream = sample;
	player.pitch_scale = pitch;
	player.play(begin);
	
	get_tree().create_timer(end - begin).connect("timeout", self, "_stop", [player], CONNECT_ONESHOT);


func cache_sound(sample: AudioStreamSample, pitch: float) -> void:
	var player = AudioStreamPlayer.new();
	add_child(player);
	
	player.bus = "Effects";
	player.stream = sample;
	player.pitch_scale = pitch;
	
	_cache[sample] = {
		"player": player,
	};


func play_cached(sample: AudioStreamSample) -> void:
	var cache = _cache.get(sample);
	
	if cache != null:
		cache["player"].play();
	

func _stop(player) -> void:
	player.stop();
	player.queue_free();
