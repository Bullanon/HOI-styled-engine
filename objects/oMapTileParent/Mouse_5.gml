// ADDS UNIT  TO DEPLOY POOL
if keyboard_check(vk_control) and units_selected != -1
	and mouse_x >= my_x-15 and mouse_x <= my_x+15
	and mouse_y >= my_y-15 and mouse_y <= my_y+15 and owner == global.player{
		
		var _unit = units_list[| units_selected],
			o_id = global.faction_id_map[? owner];
		
		if o_id.units[? _unit][| 15] == 0{// CAN STRATEGICALLY REDEPLOY ONLY WHEN IDLE
			
		ds_list_delete(units_list, units_selected);
		ds_list_replace(o_id.units[? _unit], 4, 2); // Change units INDEPLOY value to waiting
		if o_id.units[? _unit][| 5] != undefined{//remove path
			ds_list_destroy(o_id.units[? _unit][| 5]);
			ds_list_insert(o_id.units[? _unit], 5, undefined);
		}
		
		// Remove from movement
		 if ds_list_find_index(moving_units_list, _unit) != -1{
				var _index = ds_list_find_index(moving_units_list, _unit);
				// ADD UNDEFINED REMOVE IF IT BECOMES AN ERROR
				ds_list_delete(moving_units_list, _index);
				ds_list_delete(move_to_list, _index);
				ds_list_delete(distance_list, _index);
				
				move_to--;
				
		 }
		}
}else{
	global.target_tile_id = id;
	global.pressed_x = mouse_x;
	global.pressed_y = mouse_y;
}