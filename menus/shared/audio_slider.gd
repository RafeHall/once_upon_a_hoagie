extends HSlider


export var audio_effect: AudioStreamSample = null;
export var start: float = 0.0;
export var end: float = 1.0;
export var pitch: float = 1.0;


func _ready() -> void:
	call_deferred("connect", "value_changed", self, "_value_changed");


func _value_changed(_value: float) -> void:
	if audio_effect != null:
		UiAudioServer.play_sound(audio_effect, start, end, pitch);
