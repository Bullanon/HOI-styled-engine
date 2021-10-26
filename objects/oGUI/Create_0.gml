// Set starting X and Y to capital location
global.frame = 0;
alarm[0] = 7;

// MOUSE VAR
px = -1;
py = -1;

	
//Spawn ingame menu
instance_create_depth(0, 0, 0, oInGameMenu);

// Set time get later from scr_get_init
global.selected_tile_id = "";
global.target_tile_id = "";
global.paused = false;
global.spd = 0;
global.game_spd = ds_list_create();
ds_list_add(global.game_spd, 1, 3, 20, 60, 120);
timer = global.game_spd[| global.spd];
global.hour = 0;
hour = global.hour;
global.day = 0;
day = global.day;
global.months = ds_list_create();
ds_list_add(global.months, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
global.month_days = ds_list_create();
ds_list_add(global.month_days, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
global.month_index = 0;
month_index = global.month_index;
global.year = 2030;
year = global.year;

global.map_mode = 0;

	

// Create countries
global.faction_id_map = ds_map_create();
global.spawn_country_as = 0;
var _lis_len = ds_map_size(global.faction_data);
for (var i = 0; i < _lis_len; i++){
	instance_create_depth(0, 0, 0, oCountry);
}

// Create base map tiles
global.spawn_as = 0;
map_create(global.prov_amount);

// Create camera
var _cap_id = global.province_id_list[? global.faction_id_map[? global.player].capital];
instance_create_depth(_cap_id.my_x, _cap_id.my_y, 0, oCamera);