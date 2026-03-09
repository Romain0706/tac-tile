## AudioManager.gd
## Sound and music management singleton.
## Handles background music, sound effects, and volume settings.
extends Node

# Signals
signal volume_changed(type: String, value: float)

# Constants
const MUSIC_BUS := "Music"
const SFX_BUS := "SFX"
const MASTER_BUS := "Master"

# State
var _current_music_track: String = ""
var _music_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _sfx_pool_size: int = 8
var _sfx_pool_index: int = 0


func _ready() -> void:
	_setup_audio_buses()
	_setup_music_player()
	_setup_sfx_pool()


## Play background music
func play_music(track_path: String, _fade_duration: float = 1.0) -> void:
	if track_path == _current_music_track and _music_player.playing:
		return

	# TODO: Implement fade transition
	var stream := load(track_path) as AudioStream
	if stream == null:
		push_error("Failed to load music track: " + track_path)
		return

	_music_player.stream = stream
	_music_player.play()
	_current_music_track = track_path


## Stop background music
func stop_music(_fade_duration: float = 1.0) -> void:
	# TODO: Implement fade out
	_music_player.stop()
	_current_music_track = ""


## Play a sound effect
func play_sfx(sound_id: String, volume_db: float = 0.0) -> void:
	# TODO: Load sound from sound_id mapping
	# For now, use path directly
	var stream := load(sound_id) as AudioStream
	if stream == null:
		push_error("Failed to load SFX: " + sound_id)
		return

	var player := _get_available_sfx_player()
	player.stream = stream
	player.volume_db = volume_db
	player.play()


## Set volume for a bus (0.0 to 1.0)
func set_volume(bus_name: String, value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("Audio bus not found: " + bus_name)
		return

	var db := linear_to_db(clampf(value, 0.0, 1.0))
	AudioServer.set_bus_volume_db(bus_index, db)
	volume_changed.emit(bus_name, value)


## Get current volume for a bus (0.0 to 1.0)
func get_volume(bus_name: String) -> float:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return 0.0

	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))


## Mute/unmute a bus
func set_muted(bus_name: String, muted: bool) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return

	AudioServer.set_bus_mute(bus_index, muted)


## Check if a bus is muted
func is_muted(bus_name: String) -> bool:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return false

	return AudioServer.is_bus_mute(bus_index)


func _setup_audio_buses() -> void:
	# Ensure buses exist
	# Note: In Godot 4, buses are typically set up in project settings
	pass


func _setup_music_player() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = MUSIC_BUS
	add_child(_music_player)


func _setup_sfx_pool() -> void:
	for i in range(_sfx_pool_size):
		var player := AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		_sfx_pool.append(player)


func _get_available_sfx_player() -> AudioStreamPlayer:
	# Find a player that's not playing
	for player in _sfx_pool:
		if not player.playing:
			return player

	# All players busy, use round-robin
	var player := _sfx_pool[_sfx_pool_index]
	_sfx_pool_index = (_sfx_pool_index + 1) % _sfx_pool_size
	return player
