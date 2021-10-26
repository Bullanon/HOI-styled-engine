wealth = 50;
wp = 0;
battles_fought_list = ds_list_create();
deserting_units_list = ds_list_create();
fleeing_units_list = ds_list_create();
/// NOT SAVED


selected = false;
in_view = false;
units_selected = -1;
/* Init tile core data
feed data to host faction

*/


tile_id = string(global.spawn_as);
ds_map_add(global.province_id_list, string(tile_id), id);
global.spawn_as++;
if tile_id < 72{
	sprite_index = s1;
	image_index = tile_id;
}else{
	sprite_index = s2;
	image_index = tile_id-72;
}

//object_set_sprite(0, "s" + tile_id);
image_index = tile_id;
my_x = real(global.data[? tile_id][? "x"]);
my_y = real(global.data[? tile_id][? "y"]);
owner = global.data[? tile_id][? "owner"];
_name = global.data[? tile_id][? "name"];
ter = real(global.data[? tile_id][? "ter"]);
my_h = global.hour;
my_d = global.day;
/*
		0 TYPE
		1 SPRITE
		2 MP
		3 SPD
		4 IN DEPLOY POOL? 0=no 1=yes 2=waiting in que
		5 UNIT PATH PLAN undefined=no path path(ds_list)=path
		6 supply consumption
		
		NOT SAVED:
		
		ADD A CASE FOR EVERY UNIT IN THE GAME!!!
		*/

units_list = ds_list_create();
var o_id = global.faction_id_map[? owner];
var _lis = global.data[? tile_id][? "units"]
var _lis_len = ds_list_size(_lis)
for (var i = 0; i < _lis_len; i++){// create starting units
	var _u = _lis[| i];
	if _u != 0{
		var	_unit_type = o_id.unit_types,
			_u = string(real(_u)+_unit_type),
			_u_name = global.unit_data[? _u][? "name"] + "." + string(global.unit_count) + "." + owner;
		ds_map_add(o_id.units, _u_name, unit_data_create(real(_u), 0));
		ds_list_add(units_list, _u_name);
	}
}




/// Unit movement inits
move_to = 0;
move_to_list = ds_list_create();
distance_list = ds_list_create();
moving_units_list = ds_list_create();

// color = faction; ADD ITEM TO JSON
color_t = ds_map_find_value(global.colors, owner);

// Add base stats to json and get them here
max_ic = global.data[? tile_id][? "ic"];
ic = max_ic;
pop = global.data[? tile_id][? "pop"]*1000;


// CLEAN UP UNUSED GLOBAL DATA
// MIGHT CAUSE A PROBLEM WITH scr_global_init
ds_list_destroy(global.data[? tile_id][? "units"]);
ds_map_delete(global.data, "owner");
ds_map_delete(global.data, "ic");
ds_map_delete(global.data, "pop");
ds_map_delete(global.data, "ter");


if owner == global.player and global.faction_id_map[? owner].capital == tile_id{
	selected = true;
	global.prov_menu = id;
}


// NOT SAVED:
og_owner = owner;
