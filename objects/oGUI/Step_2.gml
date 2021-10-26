x = device_mouse_x_to_gui(0);
y = device_mouse_y_to_gui(0);
if global.loading{// Load globals here
	global.hour = hour;
	global.day = day;
	global.month_index = month_index;
	global.year = year;
	global.loading = false;
}


// reset right click so units wont move again ones clicked
global.target_tile_id = "";