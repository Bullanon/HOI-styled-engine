/// @description DEBUGGIN

if selected and global.debug{// TEST DRAW AI ECONOMY and shit
	var o_id = global.faction_id_map[? owner];
	draw_set_color(c_white);
	draw_text(800, 70, string(o_id.ic_funding));
	draw_text(800, 100, string(o_id.ic_in_production) + "/" + string(o_id.ic_production_need));
	draw_text(800, 130, string(o_id.ic_in_supply) + "/" + string(o_id.ic_supply_need));
	draw_text(800, 160, string(o_id.ic_reinforce_need) + "/" + string(o_id.ic_in_reinforce));
	
	draw_text(780, 180, ds_list_size(moving_units_list));
	if ds_list_size(distance_list) > 0 draw_text(780, 200, distance_list[| 0]);
	
	draw_text(780, 220, ds_list_size(o_id.at_war_with));
	
	draw_text(300, 100, "prov units: " + string(ds_list_size(units_list)));
	draw_text(300, 130, "Fleeing units: " + string(ds_list_size(fleeing_units_list)));
	draw_text(300, 160, "Deserting units: " + string(ds_list_size(deserting_units_list)));
	
	draw_text(780, 250, "Units: " + string(ds_map_size(o_id.units)));
	
	var _key = ds_map_find_first(o_id.units),
		_y = 0;
	for (var i = 0; i < ds_map_size(o_id.units); i++){
		draw_text(800, 280+_y, _key);
		_y += 30;
		_key = ds_map_find_next(o_id.units, _key);
	}
	
	draw_text(100, 100, string(my_x) + "  " + string(my_y));
}