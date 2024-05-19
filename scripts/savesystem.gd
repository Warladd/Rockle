extends Node

var save_game := SaveFile.new()
var settings := Settings.new()
var keybinds := Keybinds.new()

func saving() -> void:
	var err
	if OS.has_feature("standalone"):
		err = ResourceSaver.save(save_game, "user://savegame.res")
	else:
		err = ResourceSaver.save(save_game, "user://savegame.tres")
	if err != OK:
		print("Save Game Error: ", err)

func save_keybinds() -> void:
	var err
	if OS.has_feature("standalone"):
		err = ResourceSaver.save(keybinds, "user://keybinds.res")
	else:
		err = ResourceSaver.save(keybinds, "user://keybinds.tres")
	if err != OK:
		print("Save Game Error: ", err)

func save_settings() -> void:
	var err
	var keybind_err
	if OS.has_feature("standalone"):
		err = ResourceSaver.save(settings, "user://settings.res")
	else:
		err = ResourceSaver.save(settings, "user://settings.tres")
	if err != OK:
		print("Settings Save Error: ", err)
	if keybind_err != OK:
		print("Keybinds Save Error: ", keybind_err)

func load_game() -> void:
	if !FileAccess.file_exists("user://savegame.tres") and !FileAccess.file_exists("user://savegame.res"):
		return
	if OS.has_feature("standalone"):
		save_game = ResourceLoader.load("user://savegame.res")
		settings = ResourceLoader.load("user://settings.res")
	else:
		save_game = ResourceLoader.load("user://savegame.tres")
		settings = ResourceLoader.load("user://settings.tres")

func restart() -> void:
	save_game = SaveFile.new()
	saving()

