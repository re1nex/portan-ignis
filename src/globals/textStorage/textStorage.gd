extends Node


const res_path = "res://resource/textStorage/"
const default_lang = GlobalVars.User_lang.ENGLISH
const _file_names = {
	GlobalVars.Storage_string_id.MENU: res_path + "menu.cfg",
	GlobalVars.Storage_string_id.HINT: res_path + "hint.cfg",
}
const load_error_string = {
	GlobalVars.User_lang.ENGLISH: "[Text not found]",
	GlobalVars.User_lang.RUSSIAN: "[Текст не найден]",
}
const lang_prop = {
	GlobalVars.User_lang.ENGLISH: "Eng",
	GlobalVars.User_lang.RUSSIAN: "Rus",
}

var _lang = default_lang
var current_res_path
var _loaded_resources = {
	GlobalVars.Storage_string_id.MENU: ConfigFile.new(),
	GlobalVars.Storage_string_id.HINT: ConfigFile.new(),
}


func _ready():
	_load_text()
	_lang=Settings.Language
	set_lang(_lang)


# storage is GlobalVars.Storage_string_id enum
func get_string(storage_enum, str_id):
	return _loaded_resources[storage_enum].get_value(str_id, lang_prop[_lang], load_error_string[_lang])


func set_lang(to_lang):
	Settings.Language = to_lang
	_lang = to_lang


func _load_text():
	for cur_prop in GlobalVars.Storage_string_id.values():
		_loaded_resources[cur_prop].load(_file_names[cur_prop])
