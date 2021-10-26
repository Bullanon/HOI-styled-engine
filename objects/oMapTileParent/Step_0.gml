if color_t == undefined{
	color_t = c_lime;
}



var o_id = global.faction_id_map[? owner];
if selected{
	global.selected_tile_id = id; // pointless atm
	if ds_list_size(units_list) == 0{// check if units have left prov
		units_selected = -1;
	}
	
	#region// UNIT MOVEMENTS ON CLICK
	if global.target_tile_id != "" and units_selected != -1{// Send troops to attack or move
		var _id = global.target_tile_id;
		if ds_list_find_index(o_id.at_war_with, _id.owner) != -1 or owner == _id.owner{
		
		var _selected_unit_from_moving_list = ds_list_find_index(moving_units_list, units_list[| units_selected]);
		var _selected_unit_data = o_id.units[? units_list[| units_selected]];
		
		if _id != id{/// CHECK IF CLICK IS NOT SELECTED
			var _lis = global.data[? tile_id][? "path"];
			var _lis_len = ds_list_size(_lis);
			var _direct_path = false;
			
			for (var i = 0; i < _lis_len; i++){
				if _id.tile_id == _lis[| i]{
					_direct_path = true;
					break;
				}
			}
			
			
	
				if _direct_path and _selected_unit_data[| 15] != 2{
					instance_create_depth(global.pressed_x, global.pressed_y, 0, oRightS);
					// Add check if hostile or not
					if move_to > 0 and _selected_unit_from_moving_list != -1{
						// Checks if unit already moving to a target
						if _selected_unit_data[| 5] != undefined{//clear old path and move data
							ds_list_destroy(_selected_unit_data[| 5]);
							ds_list_replace(_selected_unit_data, 5, undefined);
						}
						/// NEW TARGET ASIGNMENT
						
						ds_list_replace(move_to_list, _selected_unit_from_moving_list, _id.tile_id);
						ds_list_replace(distance_list, _selected_unit_from_moving_list, point_distance(my_x, my_y, _id.my_x, _id.my_y));
					
						
					
						// MOVE ALL TROOPS, you have to reset those going to new locations 
						// And send them to new target
					}else{// MOVE UNIT TO NEW PROV

						unit_move_add(id, _id, units_list[| units_selected]);
					}
		}else if !_direct_path and _selected_unit_data[| 15] != 2{ // ADD PATH PLAN TO TARGET (MIGHT NEED REPLACE OF FORMER PATH OPTION)
			
			if _selected_unit_data[| 5] != undefined{//clear old path and move data
				ds_list_destroy(_selected_unit_data[| 5]);
				ds_list_replace(_selected_unit_data, 5, undefined);
			}

			if move_to > 0 and ds_list_find_value(moving_units_list, _selected_unit_from_moving_list) != undefined{
				// ADD UNDEFINED REMOVE IF IT BECOMES AN ERROR
				ds_list_delete(moving_units_list, _selected_unit_from_moving_list);
				ds_list_delete(move_to_list, _selected_unit_from_moving_list);
				ds_list_delete(distance_list, _selected_unit_from_moving_list);
				
				move_to--;
				
				if _selected_unit_data[| 15] == 1 _selected_unit_data[| 15] = 0;// Cancel potential attack status
			}
			
			
			// Add path to unit
				ds_list_replace(_selected_unit_data, 5, get_path_to_province_test(tile_id, _id.tile_id, o_id.at_war_with, o_id._name));
				var _path = _selected_unit_data[| 5];
				if _path != undefined{// CHECK IF PATH FROM FUNCTION IS VALID
					_path = _path[| 0];
					var _index = global.province_id_list[? _path];
					
					unit_move_add(id, _index, units_list[| units_selected]);
					
					instance_create_depth(global.pressed_x, global.pressed_y, 0, oRightS);
				}
		}
		
		}else if _selected_unit_from_moving_list != -1{// CANCEL UNIT MOVE TO PROV
				// ADD UNDEFINED REMOVE IF IT BECOMES AN ERROR
				ds_list_delete(moving_units_list, _selected_unit_from_moving_list);
				ds_list_delete(move_to_list, _selected_unit_from_moving_list);
				ds_list_delete(distance_list, _selected_unit_from_moving_list);
				
				move_to--;
				
				if _selected_unit_data[| 15] == 1 _selected_unit_data[| 15] = 0;// Cancel potential attack status
				
				if _selected_unit_data[| 5] != undefined{// Check for path data to clear
					ds_list_destroy(_selected_unit_data[| 5]);
					ds_list_replace(_selected_unit_data, 5, undefined);
				}
		
		} // end of if id 
		
	}
		global.target_tile_id = "";
		instance_create_depth(global.pressed_x, global.pressed_y, 0, oRightF);
	}
	#endregion
	

}else{// not selected
	image_alpha = 1;
}// END OF IF SELECTED








if my_h != global.hour{
	
	#region// PER H
	
	
	
	
	
	#region// PATHED UNITS STARTS MOVING TO NEW PROVINCE IF NOT MOVING AND HAS PATH
	_lis_len = ds_list_size(units_list);
	for (var i = 0; i < _lis_len; i++){// go trough units in prov


		var _unit_path = o_id.units[? units_list[| i]][| 5];
		if _unit_path != undefined and ds_list_find_index(moving_units_list, units_list[| i]) == -1{// check if unit has path and isn't moving
			
			
				// Delete first item in path and if empty replace with undefined
				if ds_list_size(_unit_path) > 1{
					
					ds_list_delete(_unit_path, 0);// delete last step of path and start walking to new target
					var _paths = global.data[? tile_id][? "path"],
						_id = global.province_id_list[? _unit_path[| 0]];// next tile from path
						
					if ds_list_find_index(_paths, _unit_path[| 0]) == -1{// if path is not direct cancel it
						ds_list_replace(o_id.units[? units_list[| i]], 5, undefined);
						ds_list_destroy(_unit_path);
						global.debug_jump++;
					}else if _id.owner != owner and ds_list_find_index(o_id.at_war_with, _id.owner) == -1{// CHECK IF NEXT STEP IN PATH ISN't AVAILABLE if so skip add move and nuke path
						ds_list_destroy(o_id.units[? units_list[| i]][| 5]);
						ds_list_replace(o_id.units[? units_list[| i]], 5, undefined);// PATH CANCELED
					}else{
					
						//unit_move_add(id, _id, units_list[| i]);
						
						unit_move_add(id, _id, units_list[| i]);
						
						/*
						move_to++;
						ds_list_add(move_to_list, _id.tile_id);
						ds_list_add(distance_list, point_distance(my_x, my_y, _id.my_x, _id.my_y));
						ds_list_add(moving_units_list, units_list[| i]);
						*/
						//show_debug_message("UNIT STARTING TO MOVE TO NEW PROV " + tile_id  + " to " + _id.tile_id);
					}
				}else{
					ds_list_destroy(o_id.units[? units_list[| i]][| 5]);
					ds_list_replace(o_id.units[? units_list[| i]], 5, undefined);// UNIT CONCLUDED PATH
				}
		}
	}
	#endregion



	// UNIT MOVES PER H TO TARGET
	if move_to > 0{
		
		var _atk = 0,
			_h_atk = 0,
			_ter_p = 0,
			_morale = 0,
			_org = 0,
			_attacker_amount = 0,
			_attackers = ds_list_create();
			
		for (var i = 0; i < move_to; i++){
			var l = distance_list[| i],
				_id = global.province_id_list[? move_to_list[| i]],
				_unit_name = moving_units_list[| i],
				_moving_u = o_id.units[? _unit_name];
			
			
			_ter_p = round_ext(real(global.ter_data[? string(_moving_u[| 11])][? string(_id.ter)])*ter_tech_move_mod(_id.ter, o_id), .1);
			
			if l > 0 l -= (o_id.units[? _unit_name][| 3]*_ter_p);// MOVE TOWARDS PROV
			if _id.owner != owner and _moving_u[| 13] > 0 _moving_u[| 13] -= 0.01;
			ds_list_replace(distance_list, i, l);
			
			if ds_list_size(_id.units_list) > 0 and _id.owner != owner and ds_list_find_index(battles_fought_list, _id) == -1{// Battle

				show_debug_message("in battle");
				show_debug_message(tile_id);
			
				
				var _lis_size = ds_list_size(moving_units_list);
				for (var i2 = 0; i2 < _lis_size; i2++){// loop trough moving units to determine attackers
					
					if move_to_list[| i2] == _id.tile_id{//check if unit attacking to battle target
						
						// attacking unit's stats
						var _u_name = moving_units_list[| i2],
							_u = o_id.units[? _u_name];
						_atk += _u[| 7]*_ter_p;
						_h_atk += _u[| 9]*_ter_p;
						_morale += _u[| 12];
						_org += _u[| 13];
						_attacker_amount++;
						ds_list_add(_attackers, _u_name);
						_u[| 15] = 1;// SET UNIT STATUS TO ATTACKING
						
						
					}	
				}
						
				// and ds_list_find_index(_attackers, units_list[| i]) == -1
			}else if l <= 0 and ds_list_find_index(battles_fought_list, _id) == -1{// Distance is reached, changing prov
				if owner == _id.owner or ds_list_find_index(o_id.at_war_with, _id.owner) != -1{// CHECK IF MOVE STILL LEGAL
				ds_list_delete(distance_list, i);
				
				var _move_mouse = false;
				// If unit selected follow with mouse
				if selected and units_list[| units_selected] == moving_units_list[| i] _move_mouse = true;

				
				
				// Add unit to new province
				ds_list_delete(moving_units_list, i);	
				ds_list_add(_id.units_list, _unit_name);
		
				// Move mouse select
				if _move_mouse{
					selected = false;
					_id.selected = true;
					_id.units_selected = ds_list_find_index(_id.units_list, _unit_name);
					units_selected = -1;
					global.prov_menu = _id;
				}

				
				// Delete data from old province
				var _pos = ds_list_find_index(units_list, _unit_name);
				ds_list_delete(units_list, _pos);
				ds_list_delete(move_to_list, i);

				
				move_to--;
				
				// ADD PROVINCE TO NEW OWNER and reduce it's attributes
				if _id.owner != owner{
					show_debug_message("UNITS OCCUPY NEW PROV!");
					ds_list_insert(oInGameMenu.log_list, 0, owner + " captured " + _id._name + " from " + _id.owner);
					_id.owner = owner;
					_id.ic = 0;
					_id.pop -= _id.pop*0.02;
					if country_get_id(_id.owner).scortched_earth == true{
						_id.max_ic = 0;// IC burned to ground
						_id.wealth -= 30;
					}
					_id.wealth -= 5;
					ds_map_replace(global.data[? _id.tile_id], "owner", owner);
				}
				//global.data[? _id.tile_id][? "owner"];
				
			}else{// CAPTURING PROV WAS NO LONGER LEGAL
				unit_move_delete(id, _unit_name);
				
			}
				
				if move_to = 0{
					// Clear check for undefined
					ds_list_clear(moving_units_list);
					ds_list_clear(move_to_list);
					ds_list_clear(distance_list);
				}
			}// end of if in fight


			// Battle clac zone
			if _attacker_amount > 0{// units are attacking, calculate defender stats and do battle
				
				
				show_debug_message("ENTERING BATTLE CALCULATION");
				var d_defenders = ds_list_size(_id.units_list),
					d_def = 0,
					d_morale = 0,
					d_org = 0,
					d_defender_amount = 0,
					d_id = global.faction_id_map[? _id.owner],
					d_ter_p = 0;
				for (var i2 = 0; i2 < d_defenders; i2++){// get defender stats
					_u = d_id.units[? _id.units_list[| i2]];
					d_ter_p = real(global.ter_data[? _u[| 11]][? string(_id.ter)]);
					d_def += _u[| 8]*d_ter_p;
					d_morale += _u[| 12];
					d_org += _u[| 13];
					d_defender_amount++;
					if _u[| 15] != 1 _u[| 15] = 2;// IF NOT ATTACKING SET UNIT STATUS TO DEFENDING
				}
				// calculate damage
				_h_atk = _h_atk/_attacker_amount;

				_atk = round((_atk*(round(_morale)+1/_attacker_amount))*((_org+1)/_attacker_amount)/(_attacker_amount/2));
				d_def = round((d_def*(round(d_morale)+1/d_defender_amount))*((d_org+1)/d_defender_amount));
				
				//show_debug_message("atk: " + string(_atk));
				//show_debug_message("def: " + string(d_def));
				
				var _battle_balance = round_ext(_atk/d_def, .1); //lower number good for def
				if is_nan(_battle_balance) or is_infinity(_battle_balance){
					_battle_balance = 1;
					show_message("BATTLE CALC ERROR!");
				}
				
				var	_dmg_to_attacker = (1/_battle_balance)/10,
					d_dmg_to_defender = (_battle_balance/15);
				
				
				
				//show_debug_message(_battle_balance);
				//show_debug_message("dmg: " + string(_dmg_to_attacker));
				
				var eo_id = global.faction_id_map[? _id.owner];
				for (var i2 = 0; i2 < _attacker_amount; i2++){// Inflict casualties and damage to attackers
					var _toughness = ((o_id.units[? _attackers[| i2]][| 10]+1)/2)/1000;
					_dmg_to_attacker = _dmg_to_attacker -_toughness;
					if _dmg_to_attacker < 0 _dmg_to_attacker = 0;
					var _casualties = round(global.unit_data[? string(o_id.units[? _attackers[| i2]][| 0])]*_dmg_to_attacker);
					o_id.units[? _attackers[| i2]][| 2] -= _casualties;//dmg to mp
					o_id.taken_cas += _casualties;
					eo_id.inflicted_cas += _casualties;
					if _battle_balance < 1.1 and o_id.units[? _attackers[| i2]][| 12] > 1 o_id.units[? _attackers[| i2]][| 12] -=  0.01;// units lose morale fighting a losing battle
					o_id.units[? _attackers[| i2]][| 13] -= 1/_battle_balance;//org loss
					if o_id.units[? _attackers[| i2]][| 13] < 1 or is_nan(o_id.units[? _attackers[| i2]][| 13]) or is_infinity(o_id.units[? _attackers[| i2]][| 13]) o_id.units[? _attackers[| i2]][| 13] = 0;
					if o_id.units[? _attackers[| i2]][| 13] < o_id.units[? _attackers[| i2]][| 12]*2 or o_id.units[? _attackers[| i2]][| 2] < 200{// org drops below morale * 2 retreating
						o_id.units[? _attackers[| i2]][| 13] = 0;//org to 0
						if o_id.units[? _attackers[| i2]][| 12] >= 1.5 o_id.units[? _attackers[| i2]][| 12] -= 0.5;//morale -0.5
						else o_id.units[? _attackers[| i2]][| 12] = 1;
						// CANCEL MOVE TO PROV 
						var _pos = ds_list_find_index(moving_units_list, _attackers[| i2]);
						ds_list_delete(moving_units_list, _pos);
						ds_list_delete(move_to_list, _pos);
						ds_list_delete(distance_list, _pos);
						ds_list_insert(oInGameMenu.log_list, 0, "Units deserted the battlefield at " + _id._name + "!");
						move_to--;
						
					}
					
			}// end of dmg to attackers loop
			
			for (var i2 = 0; i2 < d_defender_amount; i2++){// Inflict casualties and damage to defenders
				show_debug_message("LOOPING TROUGH DEFENCE!");
				var _toughness = ((eo_id.units[? _id.units_list[| i2]][| 10]+1))/1000;
				d_dmg_to_defender = d_dmg_to_defender -_toughness;
				if d_dmg_to_defender < 0 d_dmg_to_defender = 0;
				var _casualties = round(global.unit_data[? string(eo_id.units[? _id.units_list[| i2]][| 0])]*d_dmg_to_defender);
				eo_id.units[? _id.units_list[| i2]][| 2] -= _casualties;//dmg to mp
				eo_id.taken_cas += _casualties;
				o_id.inflicted_cas += _casualties;
				if _battle_balance > 1.1 and eo_id.units[? _id.units_list[| i2]][| 12] > 1 eo_id.units[? _id.units_list[| i2]][| 12] -=  0.01;// units lose morale fighting a losing battle
				eo_id.units[? _id.units_list[| i2]][| 13] -= _battle_balance/2;//org loss
				if eo_id.units[? _id.units_list[| i2]][| 13] < 1 or is_nan(eo_id.units[? _id.units_list[| i2]][| 13]) or is_infinity(eo_id.units[? _id.units_list[| i2]][| 13]) eo_id.units[? _id.units_list[| i2]][| 13] = 1;
				if eo_id.units[? _id.units_list[| i2]][| 13] < eo_id.units[? _id.units_list[| i2]][| 12]*3 or eo_id.units[? _id.units_list[| i2]][| 2] < 200{// org drops below zero retreating
						
						eo_id.units[? _id.units_list[| i2]][| 13] = 0;
						ds_list_insert(oInGameMenu.log_list, 0, "Enemy units flee the battlefield at " + _id._name + "!");
						// CANCEL POTENTIAL MOVE TO PROV
						if ds_list_find_index(_id.moving_units_list, _id.units_list[| i2]) != -1{
							show_debug_message("CANCELING POTENTIAL MOVE TO PROV");
							
							unit_move_delete(_id, _id.units_list[| i2]);
							/*
							var _pos = ds_list_find_index(_id.moving_units_list, _id.units_list[| i2]);
							ds_list_delete(_id.moving_units_list, _pos);
							ds_list_delete(_id.move_to_list, _pos);
							ds_list_delete(_id.distance_list, _pos);
							_id.move_to--;
							*/
						}
						// DEFEATED DEFENDERS FIND AN ESCAPE ROUTE OR DIE!
						ds_list_add(_id.deserting_units_list, _id.units_list[| i2] + "," + _id.owner);
						//also add to owners (oCountry) deserting units list
						ds_list_add(eo_id.deserting_units_list, _id.units_list[| i2]);
					}
		
		}// end of dmg to defenders for loop
		
		if owner == global.player{//player is involved in the fighting
					ds_list_add(global.battles_list, "0&" + _id._name + "," + string(_battle_balance) + "," + string(_attacker_amount) + "," + string(d_defender_amount));		
				}else if _id.owner == global.player{
					ds_list_add(global.battles_list, "1&" + _id._name + "," + string(_battle_balance) + "," + string(_attacker_amount) + "," + string(d_defender_amount));	
		}
		
				if ds_list_size(_id.deserting_units_list) > 0{// DELETE DESERTERS FROM UNITS LIST
					show_debug_message("UNITS DESERTING!");
					for (var i2 = 0; i2 < ds_list_size(_id.deserting_units_list); i2++){
						ds_list_delete(_id.units_list, ds_list_find_index(_id.units_list, pos_split(_id.deserting_units_list[| i2], 0)));
						remove_undefined(_id.units_list);
					}
					
				}
				
				ds_list_add(battles_fought_list, _id);// Keep track of battles fought this turn
				ds_list_clear(_attackers);
				// TEMP FAIL CHECK SETTING TEMP VARS TO 0
				_atk = 0;
				_h_atk = 0;
				_ter_p = 0;
				_morale = 0;
				_org = 0;
				_attacker_amount = 0;
				d_defenders = 0;
				d_def = 0;
				d_morale = 0;
				d_org = 0;
				d_defender_amount = 0;
				d_id = 0;
				d_ter_p = 0;
			}//end of battle calculation and for loop
	
		}
		ds_list_destroy(_attackers);
		
		
	}// end of if move_to
	
	var _lis_len = ds_list_size(deserting_units_list);
	if _lis_len > 0{//UNITS ESCAPING FROM PROV
		var _lis = global.data[? tile_id][? "path"],
			_lis_size = ds_list_size(_lis),
			_can_retreat = false;
		for (var i = 0; i < _lis_size; i++){
			var _prope_id = global.province_id_list[? string(_lis[| i])];
			if _prope_id != undefined and _prope_id.owner == owner{
				var _target_prov = string(_lis[| i]);
				_can_retreat = true;// check for escape route
				break;
			}
		}
		if _can_retreat{
			for (var i = 0; i < _lis_len; i++){
				var _name1 = pos_split(deserting_units_list[| i], 0),
					_owner = pos_split(deserting_units_list[| i], 1),
					_u_o_id = global.faction_id_map[? _owner];
			
				ds_list_add(fleeing_units_list, _name1 + "," + string(point_distance(my_x, my_y, _prope_id.my_x, _prope_id.my_y) / _u_o_id.units[? _name1][| 3]) + "," + _target_prov + "," + _owner);
				ds_list_insert(oInGameMenu.log_list, 0, _name1 + " fleeing to " + _target_prov + "!");
		}
		}else{// cant retreat, kill units
			for (var i = 0; i < _lis_len; i++){
				var _name1 = pos_split(deserting_units_list[| i], 0),
					_owner = pos_split(deserting_units_list[| i], 1),
					_u_o_id = global.faction_id_map[? _owner];
				_u_o_id.taken_cas += _u_o_id.units[? _name1][| 2];
				if _u_o_id.units[? _name1][| 5] != undefined ds_list_destroy(_u_o_id.units[? _name1][| 5]);
				ds_map_delete(_u_o_id.units, _name1);
			}
		}
		ds_list_clear(deserting_units_list);
	}// end of if units escaping from prov
	
	
	#endregion// PER H END
	
	#region// PER DAY
	
	if my_d != global.day{// per day events
		my_d = global.day;
		
		
		if ic < max_ic{// Prepaire industry
			ic += max_ic/20;
			if ic > max_ic{
				ic = max_ic;
			}
		}
		
		// generate money based on pop
		wp = pop/o_id.wp_mod*wealth*o_id.tax_lvl/1000;
		wp = round(wp - wp*o_id.administration_cost);
		o_id.money_count += wp;
		
		// calculate new wealth
		wealth += (1-(o_id.mob_lvl/8)-(o_id.tax_lvl/50))/4;
		if wealth > 100 wealth = 100;
		else if wealth < 0 wealth = 0;
		
		// calculate new pop
		var _pop_growth = (pop/1000*o_id.pop_growth_mod)/(o_id.mob_lvl+1);
		pop += _pop_growth;
	}
	
	#endregion// PER DAY END
	
	ds_list_clear(battles_fought_list);
}// END OF if my_h