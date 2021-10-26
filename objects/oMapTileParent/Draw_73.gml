draw_set_color(c_white);
draw_set_font(font_basic);

if selected{
	global.selected = global.faction_id_map[? owner];
	var _lis = global.data[? tile_id][? "path"];
	var _lis_len = ds_list_size(_lis);
	for (var i = 0; i < _lis_len; i++){
		// Draw route to pathed povinces
		var _id = ds_map_find_value(global.province_id_list, string(_lis[| i]));
		
		
		/// MAKE SPECIFIC TO WHEN UNIT CLICKED add red for war
		// MAKE INTO MAP WIDE BUTTON
		switch (global.map_mode){
			case 1:
			/*
			if _id.owner == global.player{
				_id.image_blend = c_green;
			}else if ds_list_find_index(p_id.at_war_with, _id.owner) != -1{
				_id.image_blend = c_red;
			}else{
				_id.image_blend = c_yellow;
			}
			*/
			break;
			case 3:
			draw_set_color(c_blue);
			draw_arrow(my_x, my_y, _id.my_x, _id.my_y, 20);
			draw_set_color(c_white);
			break;
			
			default:
			break;
			
		}
	}
	
}

switch (global.map_mode){
	case 1:
	var _state = global.data[? tile_id][? "state"];
		draw_set_color(c_white);
			switch (_state){
				case "Texas":
				image_blend = c_yellow;
				break;
				case "New Mexico":
				image_blend = global.cus_0;
				break;
				case "California":
				image_blend = c_green;
				break;
				case "Arkansas":
				image_blend = global.cus_1;
				break;
				case "Arizona":
				image_blend = global.cus_2;
				break;
				case "Nevada":
				image_blend = global.cus_3;
				break;
				case "Oregon":
				image_blend = global.cus_5;
				break;
				case "Washington":
				image_blend = global.cus_4;
				break;
				case "Idaho":
				image_blend = global.cus_9;
				break;
				case "Montana":
				image_blend = global.cus_7;
				break;
				case "Wyoming":
				image_blend = global.cus_8;
				break;
				case "Utah":
				image_blend = global.cus_6;
				break;
				case "Colorado":
				image_blend = global.cus_10;
				break;
				case "Dakota":
				image_blend = global.cus_11;
				break;
				case "Kansas":
				image_blend = global.cus_12;
				break;
				case "Michigan":
				image_blend = global.cus_13;
				break;
				case "Missouri":
				image_blend = global.cus_14;
				break;
				case "Illinois":
				image_blend = c_lime;
				break;
				case "Louisiana":
				image_blend = c_maroon;
				break;
			
			}
	break;

	case 2:// diplomatic map
	if owner == global.selected._name{
		image_blend = c_green;
	}else if ds_list_find_index(global.selected.at_war_with, owner) != -1{
		image_blend = c_red;
	}else{
		image_blend = c_yellow;
	}
	break;
	
	case 3:
	var _terrain = global.data[? tile_id][? "ter"];
	switch (_terrain){
		case 0:
		image_blend = global.cus_6;
		break;
		case 1:
		image_blend = global.cus_2;
		break;
		case 2:
		image_blend = global.cus_15;
		break;
		case 3:
		image_blend = global.cus_0;
		break;
		case 4:
		image_blend = global.cus_10;
		break;
		case 5:
		image_blend = global.cus_8;
		break;
		case 6:
		image_blend = global.cus_1;
		break;
	}
	
	break;
	
	case 4:
	image_blend = make_color_rgb(255*(pop/100000), 100*(pop/100000), 0);
	break;
	
	default:
	
	break;
}


// UNIT MOVE AND SELECT
if ds_list_size(units_list) > 0 and in_view and units_list[| 0] != undefined{// in view and units exist
	draw_set_color(c_black);
	if units_selected > ds_list_size(units_list)-1{// Make sure not trying to draw a unit that moved to a new tile
		units_selected = ds_list_size(units_list)-1;
	}
	
	var o_id = global.faction_id_map[? owner];

		var _u_to_draw = units_selected;
		if units_selected == -1 _u_to_draw = 0;
		var _unit_data = o_id.units[? units_list[| _u_to_draw]];
		if _unit_data = undefined{
			/*
			show_debug_message("CANNOT FIND OVER 0");
			show_debug_message(units_selected);
			show_debug_message(units_list[| units_selected]);
			*/
			_unit_data = o_id.units[? units_list[| 0]];
			units_selected = -1;
		}else{
			var _index = 0;
			if units_selected != -1{
				draw_sprite(sUnitSelected, 0, my_x, my_y);// draw selected circle
				_index = units_selected;
				
				if ds_list_find_index(moving_units_list, units_list[| _index]) != -1{
					#region// DRAW ATTACK ARROW
		draw_set_color(c_white);
		depth = -100;
		for (var i = 0; i < move_to; i++){
			var _id = global.province_id_list[? move_to_list[| i]];
			
			if _id.owner != owner{// ADJUST MOVE ARROW COL (ADD BATTLE CHECK FOR RED) ELSE YELLLOW)
				var _bot_col = global.bot_red;
					_ove_col = global.ove_red;
			}else{
				var _bot_col = global.bot_green,
					_ove_col = global.ove_green;
			}
			
			// DRAW MOVE ARROW
			var	total_distance = point_distance(my_x, my_y, _id.my_x, _id.my_y),
				moved_to_target_percent = (total_distance - distance_list[| i]) / total_distance,
				_angle = point_direction(my_x, my_y, _id.my_x, _id.my_y),
				_index = round(moved_to_target_percent*10+0.5),
				_len = total_distance/100;
			
			draw_sprite_ext(sMoveArrowSmall, 0, my_x, my_y, _len, 1, _angle, _bot_col, 1);
			draw_sprite_ext(sMoveArrowSmall, _index, my_x, my_y, _len, 1, _angle, _ove_col, 1);

		}
		depth = -10;
		draw_set_color(c_black);
					#endregion
				}
				
			}
			
						// if unit has path draw it
			if owner == global.player and _unit_data[| 5] != undefined{
				var _lis_len = ds_list_size(_unit_data[| 5]),
					_last_x = my_x,
					_last_y = my_y;
				for (var i = 0; i < _lis_len; i++){
					var _prov_id = global.province_id_list[? _unit_data[| 5][| i]];
					draw_arrow(_last_x, _last_y, _prov_id.my_x, _prov_id.my_y, 4);
					_last_x = _prov_id.my_x;
					_last_y = _prov_id.my_y;
				}
			}
			
			
			if _unit_data[| 15] != 0{// unit is fighting
				draw_sprite(global.unit_sprites[| _unit_data[| 1]], 17+global.frame, my_x, my_y);
			}else if ds_list_find_index(moving_units_list, units_list[| _index]) != -1{// check if unit to draw is moving
				var _target_id = global.province_id_list[? move_to_list[| ds_list_find_index(moving_units_list, units_list[| _index])]],
					_angle = point_direction(my_x, my_y, _target_id.my_x, _target_id.my_y);

				if _angle <= 45 or _angle >= 315 _angle = 1;// move right
				else if _angle <= 315 and _angle >= 225 _angle = 13;// move down
				else if _angle <= 225 and _angle >= 135 _angle = 5;// move left
				else _angle = 9;// move down
				
				draw_sprite(global.unit_sprites[| _unit_data[| 1]], _angle+global.frame, my_x, my_y);
			}else{// draw idle
				draw_sprite(global.unit_sprites[| _unit_data[| 1]], 0, my_x, my_y);
			}
			

			
			
	}
	
	
								#region// DRAW ATTACK ARROW DEBUG!!!
								if move_to > 0{
		draw_set_color(c_white);
		depth = -100;
		for (var i = 0; i < move_to; i++){
			var _id = global.province_id_list[? move_to_list[| i]];
			
			if _id.owner != owner{// ADJUST MOVE ARROW COL (ADD BATTLE CHECK FOR RED) ELSE YELLLOW)
				var _bot_col = global.bot_red;
					_ove_col = global.ove_red;
			}else{
				var _bot_col = global.bot_green,
					_ove_col = global.ove_green;
			}
			
			// DRAW MOVE ARROW
			var	total_distance = point_distance(my_x, my_y, _id.my_x, _id.my_y),
				moved_to_target_percent = (total_distance - distance_list[| i]) / total_distance,
				_angle = point_direction(my_x, my_y, _id.my_x, _id.my_y),
				_index = round(moved_to_target_percent*10+0.5),
				_len = total_distance/100;
			
			draw_sprite_ext(sMoveArrowSmall, 0, my_x, my_y, _len, 1, _angle, _bot_col, 1);
			draw_sprite_ext(sMoveArrowSmall, _index, my_x, my_y, _len, 1, _angle, _ove_col, 1);

		}
		depth = -10;
		draw_set_color(c_black);
								}
					#endregion
	
	draw_text(my_x+15, my_y-10, ds_list_size(units_list));

	//var _amount = _unit_data[| 2]/global.unit_data[? string(o_id.unit_types*_unit_data[| 0])][? "mp"]*100;
	var _amount = _unit_data[| 13];
	draw_healthbar(my_x-16, my_y+17, my_x+15, my_y+23, _amount, c_black, c_red, c_green, 0, true, true);
	

}else if units_list[| 0] == undefined{
	ds_list_clear(units_list);
}

// RETREATING UNITS
if ds_list_size(fleeing_units_list) > 0 and in_view{
	var _lis_size = ds_list_size(fleeing_units_list);
	for (var i = 0; i < _lis_size; i++){
		var _name = pos_split(fleeing_units_list[| i], 0),
			_distance = real(pos_split(fleeing_units_list[| i], 1)),
			_target = pos_split(fleeing_units_list[| i], 2),
			_owner = pos_split(fleeing_units_list[| i], 3);
		
			var _prope_id = tile_get_id(_target),
				total_distance = point_distance(my_x, my_y, _prope_id.my_x, _prope_id.my_y),
				_angle = point_direction(my_x, my_y, _prope_id.my_x, _prope_id.my_y),
				_len = total_distance/100;
			
			draw_sprite_ext(sMoveArrowSmall, 0, my_x, my_y, _len, 1, _angle, c_gray, 1);//retreat arrow
			
			if my_h == global.hour break;
			_distance--;
		
		if _distance < 0{
			var _prope_id2 = global.faction_id_map[? _owner],
				_u_name = pos_split(fleeing_units_list[| i], 0);
				
				
			
			if _prope_id.owner == _owner{// MADE IT BACK SAFE
				var _u_o_id = global.faction_id_map[? _owner];
				_u_o_id.units[? _name][| 13] = _u_o_id.unit_org_reqroup_mod;// Set units retreat org to default
				ds_list_add(_prope_id.units_list, _name);
			}else{// prov in enemy control == UNIT DIES	
				var o_id = global.faction_id_map[? owner];
				
				if !is_undefined(_prope_id2){// Check if country still exist (might be annexed)
					o_id.inflicted_cas += _prope_id2.units[? _u_name][| 2];
					_prope_id2.taken_cas += _prope_id2.units[? _u_name][| 2];
					if _prope_id2.units[? _u_name][| 5] != undefined ds_list_destroy(_prope_id2.units[? _u_name][| 5]);
					ds_map_delete(_prope_id2.units, _u_name);
				}
			}
			ds_list_replace(fleeing_units_list, i, undefined);
			if !is_undefined(_prope_id2) ds_list_delete(_prope_id2.deserting_units_list, ds_list_find_index(_prope_id2.deserting_units_list, _u_name));// remove from owners fleeing units
		}else{
			ds_list_replace(fleeing_units_list, i, _name + "," + string(_distance) + "," + _target + "," + _owner);
		}
		
	}
	
	remove_undefined(fleeing_units_list);
	
}

my_h = global.hour;