// Init global variables

// THINGS TO GET FROM MAIN MENU
global.player = "";
global.unit_count = 0;
global.prov_menu = "";
global.prov_amount = 117;
global.battles_list = ds_list_create();
global.selected = "";

global.country_leader_map = ds_map_create();// add leader sprites here:
ds_map_add(global.country_leader_map, "CHAZ", sCHAZleaders);
ds_map_add(global.country_leader_map, "x", sCHAZleaders);
ds_map_add(global.country_leader_map, "Greater Detroit", sCHAZleaders);
ds_map_add(global.country_leader_map, "GAY TEXAS", sCHAZleaders);
ds_map_add(global.country_leader_map, "Church of St. Bernard", sCHAZleaders);
ds_map_add(global.country_leader_map, "N.T.I", sCHAZleaders);
ds_map_add(global.country_leader_map, "MAGA Country", sCHAZleaders);
ds_map_add(global.country_leader_map, "Jesusland", sCHAZleaders);
ds_map_add(global.country_leader_map, "AWS", sCHAZleaders);
ds_map_add(global.country_leader_map, "Kekistan", sCHAZleaders);
ds_map_add(global.country_leader_map, "Silicon Valley", sCHAZleaders);
ds_map_add(global.country_leader_map, "Pillbox", sCHAZleaders);



global.moblization_name_list = ds_list_create();
ds_list_add(global.moblization_name_list, "Very low", "Low", "Medium", "High", "Very high");

/*
- Create a hand crafted base map and save as room
- Give each tile unique ID
- Give each fation it's owned tiles ID list

*/
game_set_speed(30, gamespeed_fps);

// TEMP AS MAP
global.province_id_list = ds_map_create();
global.loading = false;


// UNIT global sprite list
global.unit_sprites = ds_list_create();
ds_list_add(global.unit_sprites, sUnits, sUnits1, sUnits2);




function import_json(_file_name){
	if (file_exists(_file_name)){
		var _file, _json_string;
		_file = file_text_open_read(_file_name);
		_json_string = "";
		while (!file_text_eof(_file)){
			_json_string += file_text_read_string(_file);
			file_text_readln(_file);
		}
		file_text_close(_file);
		return json_decode(_json_string);
	}
	return undefined
}

//	C:\Users\bulla\AppData\Local\Proj_a
global.data = import_json("country_data.json");
global.faction_data = import_json("faction_data.json");
global.unit_data = import_json("units.json");
global.ter_data = import_json("ter_data.json");

// Create custom colors
global.bot_red = make_color_rgb(158, 11, 15);
global.ove_red = make_color_rgb(238, 28, 36);
global.bot_green = make_color_rgb(24, 123, 47);
global.ove_green = make_color_rgb(0, 255, 0);
global.cus_gray1 = make_color_rgb(112, 112, 112);
global.cus_brown1 = make_color_rgb(153, 91, 73);
global.menu_col1 = make_color_rgb(140, 159, 111);
global.menu_font_col1 = make_color_rgb(51, 10, 40);
global.menu_font_col1 = make_color_hsv(316, 80, 20);
global.cus_0 = make_color_rgb(136, 77, 10);
global.cus_1 = make_color_rgb(107,142,35);
global.cus_2 = make_color_rgb(192, 163, 134);
global.cus_3 = make_color_rgb(232, 156, 155);
global.cus_4 = make_color_rgb(164, 164, 164);
global.cus_5 = make_color_rgb(89, 112, 95);
global.cus_6 = make_color_rgb(112, 116, 81);
global.cus_7 = make_color_rgb(96, 80, 57);
global.cus_8 = make_color_rgb(184, 171, 110);
global.cus_9 = make_color_rgb(44, 56, 44);
global.cus_10 = make_color_rgb(53, 76, 59);
global.cus_11 = make_color_rgb(134, 184, 84);
global.cus_12 = make_color_rgb(168, 138, 134);
global.cus_13 = make_color_rgb(160, 200, 200);
global.cus_14 = make_color_rgb(200, 192, 160);
global.cus_15 = make_color_rgb(170, 35, 35);
global.cus_16 = make_color_rgb(170, 25, 15);
global.cus_17 = make_color_rgb(70, 123, 77);
global.cus_18 = make_color_rgb(0,170,190);
global.cus_19 = make_color_rgb(200,150,200);
global.cus_20 = make_color_rgb(255,165,0);
global.cus_21 = make_color_rgb(230,230,250);
global.cus_22 = make_color_rgb(218,165,32);


// Country colors
global.colors = ds_map_create();
ds_map_add(global.colors, "x", global.cus_2);
ds_map_add(global.colors, "CHAZ", global.cus_19);// Capitol Hill Autonomous Zone
ds_map_add(global.colors, "Greater Detroit", global.cus_brown1);
ds_map_add(global.colors, "GAY TEXAS", global.cus_3);
ds_map_add(global.colors, "Church of St. Bernard", global.cus_17);
ds_map_add(global.colors, "N.T.I", global.cus_7);// Northwest Territorial Imperative
ds_map_add(global.colors, "MAGA COUNTRY", global.cus_16);
ds_map_add(global.colors, "ASA", global.cus_18);// Antifacist States of America
ds_map_add(global.colors, "Jesusland", global.cus_20);
ds_map_add(global.colors, "AWS", global.cus_21);// Amazon World Syndicate
ds_map_add(global.colors, "Kekistan", global.cus_1);
ds_map_add(global.colors, "Silicon Valley", global.cus_22);
ds_map_add(global.colors, "Pillbox", global.cus_gray1);




function map_create(_amount){
	for (var i = 0; i < _amount; i++){
		instance_create_depth(800, 0, 1, oMapTileParent);
	}
}

function unit_data_create(_unit_type, _deploy){//type as int
	var _get_data = global.unit_data[? string(_unit_type)],
		data = ds_list_create();
	ds_list_add(data,
				_unit_type,
				real(_get_data[? "spr"]),
				real(_get_data[? "mp"]),
				real(_get_data[? "spd"]),
				_deploy, undefined, 
				real(_get_data[? "supply"]),
				real(_get_data[? "atk"]),
				real(_get_data[? "def"]),
				real(_get_data[? "hard_atk"]),
				real(_get_data[? "tough"]),
				_get_data[? "ter_prof"],
				5,
				100,
				0);
	global.unit_count++;
	return data;
}


function button_detect(button_x, button_y, sprite, start_index){
	var mouse_over = false,
		button_width = sprite_get_width(sprite),
		button_height = sprite_get_height(sprite),
		button_right = button_x + button_width - 1,
		button_bottom = button_y + button_height - 1;

	mouse_over = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), button_x, button_y, button_right, button_bottom);

	if !mouse_over{
		return 0; // button not pressed
	}else
	{
	    if !mouse_check_button_released(mb_left)
	    {
			return 1; // Button held down
	    } else
    {
        // action
        return 2;
    }
	}
}

function button_detect_area(button_top_right, button_bottom_right, button_top_left, button_bottom_left, start_index){
	var mouse_over = false;

	mouse_over = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), button_top_right, button_bottom_right, button_top_left, button_bottom_left);

	if !mouse_over{
		return 0; // button not pressed
	}else
	{
	    if !mouse_check_button_released(mb_left)
	    {
			return 1; // Button held down
	    } else
    {
        // action
        return 2;
    }
	}
}


function button_draw(result, sprite, start_index, button_x, button_y){
	if result == 0{
	}else if result == 1{
		draw_set_alpha(0.8);
	}else{
		draw_set_alpha(0.6);
	}
	draw_sprite(sprite, start_index, button_x, button_y);
	draw_set_alpha(1);
}

function button_draw_part(result, sprite, start_index, button_x, button_y, width, height, start_x, start_y){
	if result == 0{
	}else if result == 1{
		draw_set_alpha(0.8);
	}else{
		draw_set_alpha(0.6);
	}
	draw_sprite_part(sprite, start_index, start_x, start_y, width, height, button_x, button_y);
	draw_set_alpha(1);
}

function button_draw_index(result, sprite, start_index, button_x, button_y){
	if result == 0{
		draw_sprite(sprite, start_index, button_x, button_y);
	}else if result == 1{
		draw_sprite(sprite, start_index+1, button_x, button_y);
	}else{
		draw_sprite(sprite, start_index+2, button_x, button_y);
	}
}

function button_draw_mapmode(target, result, sprite, start_index, button_x, button_y){
	if global.map_mode == target{// selected
		draw_sprite(sprite, start_index+1, button_x, button_y);
		draw_sprite(sprite, 2+target, button_x-7, button_y);
	}else if result == 0{
		draw_sprite(sprite, start_index, button_x, button_y);
		draw_sprite(sprite, 2+target, button_x, button_y);
	}else{// mouse hover
		draw_sprite(sprite, start_index, button_x, button_y);
		draw_sprite_ext(sprite, 2+target, button_x, button_y, 1, 1, 0, c_orange, 1);
	}
}

function button_draw_streched(result, sprite, start_index, button_x, button_y, _w, _h){
	if result == 0{
	}else if result == 1{
		draw_set_alpha(0.8);
	}else{
		draw_set_alpha(0.6);
	}
	draw_sprite_stretched(sprite, start_index, button_x, button_y, _w, _h);
	draw_set_alpha(1);
}


function slider_create(_x, _y, slider_base, slider_button, _selected, _max, title){
	if _selected > _max{
		_selected = _max;
	}
	draw_text(_x, _y-60, title);
	draw_sprite(slider_base, 0, _x, _y);
	
	var percentage = _selected/_max,
		slider_button_x = _x + (sprite_get_width(slider_base) * percentage),
		_mouse_x = device_mouse_x_to_gui(0);
	
	if	abs(device_mouse_y_to_gui(0) - _y) < (sprite_get_height(slider_button)/2)
		and _mouse_x >= _x and _mouse_x <= _x + sprite_get_width(slider_base)
		and mouse_check_button(mb_left){
			var indicator_lenght = _mouse_x - _x;
				percentage = (indicator_lenght/sprite_get_width(slider_base))*100;
				_selected = round((_max/100)*percentage);
				percentage = _selected/_max;
				slider_button_x = _x + sprite_get_width(slider_base) * percentage;
		}
		draw_sprite(slider_button, 0, slider_button_x, _y);
		return _selected;
}



function slider_create_vertical(_x, _y, slider_base, slider_button, _selected, _max){
	if _selected > _max{
		_selected = _max;
	}
	draw_sprite(slider_base, 0, _x, _y);
	
	var percentage = _selected/_max,
		slider_button_y = _y + (sprite_get_height(slider_base) * percentage),
		_mouse_y = device_mouse_y_to_gui(0);
	
	if	abs(device_mouse_x_to_gui(0) - _x) < (sprite_get_width(slider_button)/2)
		and _mouse_y >= _y and _mouse_y <= _y + sprite_get_height(slider_base)
		and mouse_check_button(mb_left){
			var indicator_lenght = _mouse_y - _y;
				percentage = (indicator_lenght/sprite_get_height(slider_base))*100;
				_selected = round((_max/100)*percentage);
				percentage = _selected/_max;
				slider_button_y = _y + sprite_get_height(slider_base) * percentage;
		}
		draw_sprite(slider_button, 0, _x, slider_button_y);
		return _selected;
}



function pos_split(_string, _pos){
	var _split = string_pos(",", _string);
	for (var i = 0; i < _pos; i++){
		_split = string_pos(",", _string);
		_string = string_delete(_string, 1, _split);
	}
	if _pos == 0{
		_string = string_delete(_string, _split, string_length(_string));
	}else{
		_split = string_pos(",", _string);
		var _str_len = string_length(_string);
		_string = string_delete(_string, _split, _str_len);
	}
	return _string;
}

function dot_split(_string, _pos){
	var _split = string_pos("&", _string);
	for (var i = 0; i < _pos; i++){
		_split = string_pos("&", _string);
		_string = string_delete(_string, 1, _split);
	}
	if _pos == 0{
		_string = string_delete(_string, _split, string_length(_string));
	}else{
		_split = string_pos("&", _string);
		var _str_len = string_length(_string);
		_string = string_delete(_string, _split, _str_len);
	}
	return _string;
}



function remove_undefined(_list){
	var _sort_list = ds_list_create(),
		_lis_size = ds_list_size(_list);
	for (var i = 0; i < _lis_size; i++;){
		var _item = _list[| i];
		if(_item != undefined){
			ds_list_add(_sort_list, _item);
		}
	}
	
	ds_list_clear(_list);
	_lis_size = ds_list_size(_sort_list);
	for (var i = 0; i < _lis_size; i++;){
		ds_list_add(_list, _sort_list[| i]);
	}
	ds_list_destroy(_sort_list);
}


function tile_get_id(_tile_id){
	show_debug_message("SEARCHING TILE ID: " + _tile_id);
	with (oMapTileParent){
		if tile_id == _tile_id return id;
	}
	return "COULDN'T TILE LOCATE ID!";
}

function tile_name_get_id(_name_){
	with (oMapTileParent){
		if _name == _name_ return id;
	}
	return "COULDN'T TILE LOCATE ID!";
}

function country_get_id(name){
	with (oCountry){
		if _name == name return id;
	}
	return "COULDN'T COUNTRY LOCATE ID!";
}




function find_char_spot(str, char, index){
	var _pos = string_pos(char, str);
	for (var i = 0; i < index; i++){
		_pos = string_pos_ext(char, str, _pos);
	}
	return _pos+1;
}


function format_to_list(_string, _char){// TEST FOR A DIFFERENT PROJECT!
	/*
	takes dialogue string and divider char, returns a list
	where every other line is 1st line as string and 2nd reaction index as int
	*/
	var _split,
		_str_lis = ds_list_create();
		
	while (true){
		_split = string_pos(_char, _string);
		ds_list_add(_str_lis, string_delete(_string, _split, string_length(_string)));
		_string = string_delete(_string, 1, _split);
		ds_list_add(_str_lis, real(string_char_at(_string, 1)));
		_string = string_delete(_string, 1, 2);
		if _string == "" break;
	}
	return _str_lis;
}


function get_unit_tile_id(unit, _name){
	var _id = global.faction_id_map[? _name],
		_u = _id.units[? unit];
	if _u[| 4] == 0{
		with (oMapTileParent){
			if owner == _name and ds_list_find_index(units_list, unit) != -1 return tile_id;
		}
	}else{
		return undefined;// unit is in deploy pool
	}
	
	if _u[| 13] = 0 return undefined;// unit is either in fleeing or deserting list
	
	
	
	with (oMapTileParent){
		if ds_list_find_index(units_list, unit) != -1 show_message("UNIT IS IN ENEMY PROVINCE!");
	}
	show_debug_message("MISSING PROV");
	show_debug_message(unit);
	show_debug_message(_name);
	show_debug_message(_u[| 13]);
	if _u[| 5] != undefined ds_list_destroy(_u[| 5]);
	_id.taken_cas += _u[| 2];
	ds_list_destroy(ds_map_find_value(_id.units, unit));
	ds_map_delete(_id.units, unit);
	return undefined;
}

function is_real_number(s){
	var n = string_length(string_digits(s));
	return n and n == string_length(s) - (string_char_at(s, 1) == "-") - (string_pos(".", s) != 0);
}

function nuke_units(units){
	var map_len = ds_map_size(units),
		key = ds_map_find_first(units);
	for (var i = 0; i < map_len; i++){
		var u = units[? key];
		if u[| 5] != undefined ds_list_destroy(u[| 5]);
		ds_list_destroy(u);
		key = ds_map_find_next(units, key)
	}
	ds_map_destroy(units);
}

function declare_war(id, _id){
	if ds_list_find_index(id.at_war_with, _id._name) == -1 ds_list_add(id.at_war_with, _id._name);
	if ds_list_find_index(_id.at_war_with, id._name) == -1 ds_list_add(_id.at_war_with, id._name);
}

function make_peace(id_, _id, treaty = 0){
	if ds_list_find_index(id_.at_war_with, _id._name) != -1 ds_list_delete(id_.at_war_with, ds_list_find_index(id_.at_war_with, _id._name));
	if ds_list_find_index(_id.at_war_with, id_._name) != -1 ds_list_delete(_id.at_war_with, ds_list_find_index(_id.at_war_with, id_._name));
	
	switch (treaty){
		case 0:// WHITE PEACE
		with (oMapTileParent){// set all units in enemy territories to, return provinces to owners
			if og_owner != owner and (og_owner == id_._name or og_owner == _id._name) and (owner == id_._name or owner == _id._name){ 
				var lis_size = ds_list_size(units_list),
					c_id = global.faction_id_map[? owner],
					removed_units = array_create(0);
				for (var i = 0; i < lis_size; i++){
					removed_units[i] = units_list[| i];
					var _u = c_id.units[? removed_units[i]];
					_u[| 4] = 2;// Set in deploy pool to true
					if _u[| 5] != undefined ds_list_destroy(_u[| 5]);
					if ds_list_find_index(moving_units_list, removed_units[i]) != -1 unit_move_delete(id, removed_units[i]);
					
				}
				for (var i = 0; i < lis_size; i++){
					ds_list_delete(units_list, ds_list_find_index(units_list, removed_units[i]));
				}
				owner = og_owner;// return province to original owner
				remove_undefined(units_list);
				remove_undefined(moving_units_list);
				remove_undefined(distance_list);
				remove_undefined(move_to_list);
			}
		}
		break;
		case 1:// id_ ANNEXES CAPTURED PROVINCES
		with (oMapTileParent){
			if og_owner != owner{
				if og_owner == _id._name and owner == id_._name and tile_id != _id.capital{// id_ annexes province unless capital
					
					og_owner = owner;// province is annexed
					
				}else if og_owner == id_._name and owner == _id._name{// id_ regains province
					var lis_size = ds_list_size(units_list),
						c_id = global.faction_id_map[? owner];
					for (var i = 0; i < lis_size; i++){
						c_id.units[? units_list[| i]][| 4] = 1;// Set in deploy pool to true
					}
					owner = og_owner;// return province to original owner
				}
			}
		}
		break;
	}
}


function round_number_to_string(number){
	if number > 999999{
		var num = string(round(number/100000));
		return  string_delete(num, string_length(num), 1) + "." + string_char_at(num, string_length(num)) + "M";
	}
	else if number > 999 return string(round(number/1000)) + "k";
	else return string(number);
}

function get_string_color(str, cutoff = -1, col1 = c_green, col2 = c_red){
	if str > cutoff draw_set_color(col1);
	else draw_set_color(col2);
}

function round_ext(value, round){
	var result = (value/round)*round;
	if result == NaN or result == undefined show_message("Round error: " + string(result));
	else return result;
}


function draw_as_percent(_x, _y, num, color = c_white){
	num = num*100;
	draw_text(_x, _y, num);
	draw_set_color(color);
	draw_text(_x+string_width(string(num)), _y, "%");
}


function tomorrow(){
	if global.day+1 > global.month_days[| global.month_index]{
		var _m = global.month_index+1,
			_y = global.year;
		if _m == 12{
			_m = 0;
			_y++;
		}
		return "0." + global.months[| _m] + "." + string(_y);
	}
	return string(global.day+1) + "." + global.months[| global.month_index] + "." + string(global.year);
}
