/// @description save

var _save_data = array_create(0);

with (oMapTileParent){// for each tile
	var _units_list = array_create(0);
	var _move_to_list = array_create(0);
	var _distance_list = array_create(0);
	var _moving_units_list = array_create(0);
	
	var _lis_size = ds_list_size(units_list);
	var i = 0;
	repeat (_lis_size){
		_units_list[i] = units_list[| i];
		i++;
	}
	i = 0;
	var _lis_size = ds_list_size(move_to_list);
	repeat (_lis_size){
		_move_to_list[i] = move_to_list[| i];
		i++;
	}
	i = 0;
	repeat (_lis_size){
		_distance_list[i] = distance_list[| i];
		i++;
	}
	i = 0;
	repeat (_lis_size){
		_moving_units_list[i] = moving_units_list[| i];
		i++;
	}
	
	var _save_entity =
	{
		obj : object_get_name(object_index),
		y : y,
		x : x,
		tile_id : tile_id,
		my_x : my_x,
		my_y : my_y, 
		owner : owner,
		_name : _name,
		my_h : my_h,
		my_d : my_d,
		units_list : _units_list,
		move_to : move_to,
		move_to_list : _move_to_list,
		distance_list : _distance_list,
		moving_units_list : _moving_units_list,
		color_t : color_t,
		max_ic : max_ic,
		ic : ic,
		ter : ter,
		pop : pop,
		image_index : image_index,
		image_blend : image_blend,
		sprite_index : sprite_index
	}
	array_push(_save_data, _save_entity);
}
with (oCountry){// for each tile
	var _lis_size = ds_map_size(units);

	var _name_lis = array_create(0);
	var _data_lis = array_create(0);
	
	var _key = ds_map_find_first(units);
	var count = 0;
	for (var i = 0; i < _lis_size; i++){
		_name_lis[i] = _key;
			var loop = 0;
			repeat (6){// Make match the amount of unit attributes
				if loop == 5{
					_data_lis[count] = "x";// Set x to path
				}else{
					_data_lis[count] = units[? _key][| loop];
				}
				count++;
				loop++;
			}
		
		_key = ds_map_find_next(units, _key);
	}
	
	var _save_entity =
	{
		obj : object_get_name(object_index),
		spawn_id : spawn_id,
		_name : _name,
		ai : ai,
		relations : relations,
		unit_name_list : _name_lis,
		unit_data_list : _data_lis,
		prov_list : prov_list,
		flag : flag,
		money : money,
		total_ic : total_ic,
		mob_lvl : mob_lvl,
		tax_lvl : tax_lvl,
		my_day : my_day,
		total_pop : total_pop,
		mp : mp,
		administration_cost : administration_cost,
		ic_funding : ic_funding,
		ic_in_production : ic_in_production,
		ic_production_need : ic_production_need,
		ic_in_supply : ic_in_supply,
		ic_supply_need : ic_supply_need,
		ic_in_reinforce : ic_in_reinforce,
		ic_reinforce_need : ic_reinforce_need


	}
	array_push(_save_data, _save_entity);
}
with (oGUI){// for each tile
	
	var _save_entity =
	{
		obj : object_get_name(object_index),
		hour : global.hour,
		day : global.day,
		month_index : global.month_index,
		year : global.year

	}
	array_push(_save_data, _save_entity);
}


var _string = json_stringify(_save_data);
var _buffer = buffer_create(string_byte_length(_string) + 1 , buffer_fixed, 1);
buffer_write(_buffer, buffer_string, _string);
buffer_save(_buffer, "savedata.save");
buffer_delete(_buffer);

show_debug_message("Game saved " + _string);