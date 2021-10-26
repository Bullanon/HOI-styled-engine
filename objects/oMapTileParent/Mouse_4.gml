if global.faction_id_map[? global.player].event_ != -2{

var _menu_offset = 0;
if oInGameMenu.button_pressed != -1{
	_menu_offset += global.menu_box_x+global.menu_box_x_offset;
}

if oInGameMenu.unit_to_deploy == -1 or oInGameMenu.unit_to_deploy == -2{
	if device_mouse_y_to_gui(0) < 712 and device_mouse_x_to_gui(0) > _menu_offset and device_mouse_y_to_gui(0) > 34{// Stop mouse from clicking trough gui


		if ds_list_size(units_list) > 0 and mouse_x >= my_x-15 and mouse_x <= my_x+15
			and mouse_y >= my_y-15 and mouse_y <= my_y+15 and owner == global.player
			{
				//if !audio_is_playing(aYes) audio_play_sound(aYes, 10, 0);
			
			//and ds_list_size(units) > 0
			if units_selected < ds_list_size(units_list)-1{
				units_selected++;
				
			}else{
				// Was at last unit, start the scroll from the beginning
				units_selected = 0;
			}
		}else{
			units_selected = -1;
		}

	global.prov_menu = id;
	with (oMapTileParent){
		selected = false;
		if id != global.prov_menu units_selected = -1;
	}
	selected = true;
	global.selected_tile_id = "";





	}else if device_mouse_x_to_gui(0) > 1388  and device_mouse_y_to_gui(0) > 34{
		oCamera.x = my_x;
		oCamera.y = my_y;
	}
}else{// Deploy unit
	if owner == global.player{
		var o_id = global.faction_id_map[? owner];
		o_id.units[? oInGameMenu.unit_to_deploy][| 4] = 0;
		if o_id.units[? oInGameMenu.unit_to_deploy][| 13] > o_id.strategic_org_deploy_default o_id.units[? oInGameMenu.unit_to_deploy][| 13] = o_id.strategic_org_deploy_default;// if unit org over tech limit set it back
		ds_list_add(units_list, oInGameMenu.unit_to_deploy);
		
		oInGameMenu.unit_to_deploy = -1;
		global.map_mode = oInGameMenu.last_map_mode;
	}
}// end of if  global.faction_id_map



}