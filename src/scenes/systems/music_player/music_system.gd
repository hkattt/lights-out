class_name MusicSystem extends Node2D

@onready var music_player: AudioStreamPlayer2D = %MusicPlayer

var ominous_music: AudioStream = preload("res://assets/music/ominous-music.wav")

var musics: Dictionary[Enums.Music, AudioStream] = {
	Enums.Music.OMINOUS: ominous_music
}

func play_music(music: Enums.Music, volume_db: float = 0.0) -> void:
	if music in musics:
		var audio_stream: AudioStream = musics[music]
		if music_player.stream == audio_stream:
			return
		else:
			music_player.stop()
			music_player.stream = audio_stream
			music_player.set_volume_db(volume_db)
			music_player.play()

func _on_music_player_finished() -> void:
	music_player.play()
