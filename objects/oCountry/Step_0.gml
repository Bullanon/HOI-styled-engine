var _d_change = false;
if global.day != my_day{
	my_day = global.day;
	_d_change = true;
	#region// EVENTS
	if event_{
		switch (event_){// event effects
			case 0:// NO EFFECT
			
			break;
			case 1:// WHITE PEACE

			break;
			case 2:
			break;
			case 3:
	
			break;
			case 4:
	
			break;
		
		
		}
		event_ = -1;
	}
	#endregion
	total_pop_last_turn = total_pop;
	
	#region// Economy
	// update ic (loop by prov amount) and get total_pop and mp
	total_ic = 0;
	total_pop = 0;
	max_ic = 0;
	var _prov_count = 0,
		_prov_lis = ds_list_create(),//ai vars
		_money_change = 0;
	for (var i = 0; i < global.prov_amount; i++){// loop trough all provinces
		var _id = global.province_id_list[? string(i)];
		if _id.owner == _name{// prov owned by country
			ds_list_add(_prov_lis, _id.tile_id);
			max_ic += _id.ic;
			total_pop += _id.pop;
			_prov_count++;
			mp += (_id.pop/10000)*(mob_lvl+1);
			
			var _unit_amount = ds_list_size(_id.units_list);
			for (var i2 = 0; i2 < _unit_amount; i2++){// loop trough units in prov
				
				if _id.units_list[| i2] == undefined break;
				var _u = units[? _id.units_list[| i2]];

				if _u[| 15] == 0 _u[| 13] += (org_recovery_rate/(_u[| 13]+1));// units gain org if not in combat
				if !ai or ds_list_size(at_war_with) == 0 _u[| 15] = 0;// SET UNIT TO IDLE IF PLAYER
				
				
				if _u[| 13] > 100 _u[| 13] = 100;
				
				if _u[| 2] < 100{//mp below minimum (kill unit)
					if _u[| 5] != undefined ds_list_destroy(_u[| 5]);//clear path
					ds_list_destroy(_u);
					ds_map_delete(units, _id.units_list[| i2]);
				
					if ds_list_find_index(_id.moving_units_list, _id.units_list[| i2]) != -1{// remove from movement
						var _pos = ds_list_find_index(_id.moving_units_list, _id.units_list[| i2]);
						ds_list_delete(_id.moving_units_list, _pos);
						ds_list_delete(_id.distance_list, _pos);
						ds_list_delete(_id.move_to_list, _pos);
						
						_id.move_to--;
					}
					ds_list_delete(_id.units_list, i2);
					remove_undefined(_id.units_list);
				}
				
			}
			
		}
	}
	administration_cost = round(_prov_count/administration_cost_mod)/100;
	total_pop = round(total_pop);
	money_last_turn = money;
	money += money_count;
	money_count = 0;
	max_ic = round(max_ic);
	var _target_ic = round((max_ic*ic_funding)/100);
	for (var i = 0; i < _target_ic; i++){
		if money >= 4{
			money -= 4;
			total_ic++;
		}else{
			break;
		}
	}
	_money_change = money - money_last_turn;
	money_last_turn = money - money_last_turn;
	// Calculate supply consumption
	var _key = ds_map_find_first(units),
		_attrition = 0;
	if ic_supply_need > ic_in_supply{
		_attrition += ic_supply_need-ic_in_supply;
		if _attrition > 0 and supply_stockpile > 0{
			if _attrition <= supply_stockpile{
				supply_stockpile -= _attrition;
				_attrition = 0;
			}else{
				_attrition -= supply_stockpile;
				supply_stockpile = 0;
			}
		}
		//ds_list_insert(oInGameMenu.log_list, 0, "Units suffer attrition! (" + string(_attrition) + ") " + _name + " AI: " + string(ai));
	}else{
		supply_stockpile += ic_in_supply-ic_supply_need;
	}
	ic_supply_need = 0;
	ic_reinforce_need = 0;
	var _reinforce = ic_in_reinforce*10;// change ic to reinforce efficiency here
	if _reinforce > mp{
		_reinforce = round(mp);// not enought mp!
	}
	for (var i = 0; i < ds_map_size(units); i++){// loops trough all the units of a country
		ic_supply_need += (units[? _key][| 6]*supply_consumption_mod);// get supply need
		units[? _key][| 2] -= _attrition;// inflict attrition
		if units[? _key][| 4] == 2 and units_to_deploy_map[? _key] == undefined{
			ds_map_add(units_to_deploy_map, _key, 5);// Sets days till can be deployed to 5
		}else if units[? _key][| 4] == 2{
			units_to_deploy_map[? _key]--;
			if units_to_deploy_map[? _key] == 0{
				if !ai{
					ds_map_delete(units_to_deploy_map, _key);
					units[? _key][| 4] = 1;//unit can be deployed
				}else{
					ds_map_delete(units_to_deploy_map, _key);
					units[? _key][| 4] = 0;// ai deploy unit
					if units[? _key][| 13] > strategic_org_deploy_default units[? _key][| 13] = strategic_org_deploy_default;// if org over deploy default set it back
					var _prov_id = global.province_id_list[? _prov_lis[| 0]];
					ds_list_add(_prov_id.units_list, _key);
				}
			}
		}
		ic_supply_need = round(ic_supply_need);
		// reinforce units
		var _unit_max_mp = global.unit_data[? string(units[? _key][| 0])][? "mp"];//get max mp with type
		if units[? _key][| 2] < _unit_max_mp and _reinforce > 0{
			var _units_needed = round(_unit_max_mp  - units[? _key][| 2]);

			if _units_needed >= _reinforce and _reinforce > 0{
				_units_needed = _reinforce;
			}else if _reinforce <= 0{
				_units_needed = 0;
			}
			_reinforce -= _units_needed;
			mp -= _units_needed;
			
			units[? _key][| 2] += _units_needed;
		}
		ic_reinforce_need += _unit_max_mp-units[? _key][| 2];//+=max_mp-unit_mp
		ic_reinforce_need /= 10;
		_key = ds_map_find_next(units, _key);
	}// end of loop trough all units 
	
	var _lis_size = ds_list_size(production_list),
		_ic_to_use = ic_in_production,
		_ready = false;
	ic_production_need = 0;

	for (var i = 0 ; i < _lis_size; i++){
		var _string = production_list[| i];
		ic_production_need += real(pos_split(_string, 2));// get ic_production need
	}
	for (var i = 0 ; i < _lis_size; i++){// loop trough items on production line
		var _string = production_list[| i];
		if _string == undefined break;
		var	_type = pos_split(_string, 0),
			_tile = pos_split(_string, 1),
			_ic_need =  real(pos_split(_string, 2)),
			_days_left =  real(pos_split(_string, 3)),
			_days_total =  pos_split(_string, 4);
		
		// CANCEL IC PRODUCTION IF CAPTURED
		if _type == "IC" and global.province_id_list[? _tile].owner != _name{
			ds_list_delete(production_list, i);// cancel ic since prov captured
		}else{
		
			if _ic_to_use >= _ic_need{
				_ic_to_use -= _ic_need;
				_days_left--;
			
				if _days_left > 0{
					ds_list_replace(production_list, i, _type + "," + _tile + "," + string(_ic_need) + "," + string(_days_left) + "," + _days_total);
				}else{// product ready
					_ready = true;
				}
			}else if _ic_need > 0{// using last to spare
				var _progress = _ic_to_use/_ic_need;
				_ic_to_use = 0;
				_days_left -= _progress;
			
				if _days_left > 0{
					ds_list_replace(production_list, i,  _type + "," + _tile + "," + string(_ic_need) + "," + string(_days_left) + "," + _days_total);
					break;
				}else{// product ready
					_ready = true;
				}
			}else{// no more ic
				break;
			}
		}// end of if prov captured
	
		if _ready{// item done
			ds_list_delete(production_list, i);
			
			switch (_type){// spawn item by name
				case "IC":
				global.province_id_list[? _tile].max_ic += 1;
				break;
				
				default:// produced item didn't habve a unique identifier (defaults to a unit)
				var _u_key = global.unit_data[? _type][? "name"] + "." + string(global.unit_count) + "." + _name;
				ds_map_add(units, _u_key, unit_data_create(real(_type), 1));
				if ai{// ai deploy unit
					if ds_list_size(at_war_with) == 0{// deploy to anywhere
						
						units[? _u_key][| 4] = 0;
						var _prov_id = global.province_id_list[? _prov_lis[| 0]];
						ds_list_add(_prov_id.units_list, _u_key);
					}else if ds_list_size(at_war_with) > 0{// WARTIME DEPLOY calculate best troop replacement
						var _lis_size = ds_list_size(_prov_lis),
							_target_prov,
							_placement_value,
							_last_placement_value = -100;
						for (var i = 0; i < _lis_size; i++){
							_placement_value = 0;
							var _prov_id = global.province_id_list[? _prov_lis[| i]],
								_lis = global.data[? _prov_id.tile_id][? "path"],
								_lis_size2 = ds_list_size(_lis);
							_placement_value = 5-ds_list_size(_prov_id.units_list)*2;
							for (var i2 = 0; i2 < _lis_size2; i2++){
								if ds_list_find_index(at_war_with, global.province_id_list[? _lis[| i2]].owner) != -1 _placement_value += 2 + ds_list_size(global.province_id_list[? _lis[| i2]].units_list);
							}
							if _placement_value > _last_placement_value{
								_target_prov = _prov_lis[| i];
								_last_placement_value = _placement_value;
							}
						}//end of loop trough prov list
						// deploy unit to best spot
						units[? _u_key][| 4] = 0;
						

						var _prov_id = global.province_id_list[? _target_prov];

						ds_list_add(_prov_id.units_list, _u_key);
					}else{// ai will delete unit since no way to deploy
						mp += units[? _u_key][| 2];//return mp
						ds_map_delete(units, _u_key);//no need to check for path list
					}
				}else{
					oInGameMenu.unit_to_deploy = -2;//notify player units can be deployed
				}
				
				
				break;
			}
			if ds_list_find_value(production_list, 0) == undefined ds_list_clear(production_list);
			_ready = false;
		}
	}
	
	
	// DEVELOP TECH
	var _lis_size = ds_list_size(tech_development_list);
	research_cost = 0;
	for (var i = 0; i < _lis_size; i++){
		var _t = tech_development_list[| i],
			_cost = dot_split(_t, 0),
			_time = real(dot_split(_t, 1));
		
		// you can add check here if there's enough money!
		research_cost += round(((real(_cost)*research_funding)/100)*ds_list_size(tech_development_list));
		
		
		_time -= round((100*research_funding)/100);
		
		if _time <= 0{// tech done
			var _tech_unloch = real(dot_split(_t, 3));
			ds_list_delete(tech_development_list, i);
			i--;
			_lis_size--;
			
			show_debug_message("TECH RESEACHED");
			
			if _name == global.player and oInGameMenu.tech_display == _tech_unloch oInGameMenu.tech_display = -1;
			
			
			var _str = tech_list[| _tech_unloch],
				_pos = find_char_spot(_str, ",", 1);
			_str = string_delete(_str, _pos, 1);
			_str = string_insert("1", _str, _pos);
			ds_list_replace(tech_list, _tech_unloch, _str);
			
			get_tech_effect(unit_types, real(pos_split(_str, 3)));// GET TECH EFFECT
		}else{
			ds_list_replace(tech_development_list, i , _cost + "&" + string(_time) + "&" + dot_split(_t,2) + "&" + dot_split(_t, 3));
		}
		
	}
	money -= research_cost;
	_money_change -= research_cost;
	#endregion
	
	if ai{// AI economy
		
		var _researching = ds_list_size(tech_development_list),
			_ic_to_spare = max_ic;
			
		#region// Tech development
		/*
		if ai has no tech to develop stop this
		if ai has one tech in research check for cost estimate and decide to research
		when starting research decide it based on a list of available tech
		list tech cost with the techs and cut of any that cannot be aforded
		*/
		/*
		if _researching < global.bal_tech_research_cap and ds_exists(tech_list, ds_type_list){// reseach more tech if cap not reched and tech_list not destroyed
			
			
			var _lis_len = ds_list_size(ai_tech_list);
			show_debug_message(_lis_len);
			var	_tech_to_research = irandom_range(0, _lis_len-1);
			show_debug_message(_tech_to_research);
			show_debug_message(typeof(ai_tech_list[| _tech_to_research]));
			show_debug_message(ai_tech_list[| _tech_to_research][| 0])
			show_debug_message(ds_list_size(ai_tech_list[| _tech_to_research]));
			var	_str = tech_list[| ai_tech_list[| _tech_to_research][| 0]],
				_tech_que = lazy_hack_split(_str, 5, ",", _name + ": " + _str);
			
			// clear data to research from que
			if ds_list_size(ai_tech_list[| _tech_to_research]) == 1 ds_list_destroy(ai_tech_list[| _tech_to_research]);
			else ds_list_delete(ai_tech_list[| _tech_to_research][| 0], 0);

			//remove_undefined(ai_tech_list);
			if ds_list_size(ai_tech_list) == 0 ds_list_destroy(ai_tech_list);
			
			if _tech_que != undefined ds_list_add(tech_development_list, string(round(real(dot_split(_tech_que, 0))*tech_cost_mod)) + "&" + string(round(real(dot_split(_tech_que, 1))*tech_time_mod)) + "&" + string(round(real(dot_split(_tech_que, 1))*tech_time_mod)) + "&" + dot_split(_tech_que, 2));// cost + time + time + type
		}
		*/
		#endregion
		
		#region// Adjust ic sliders
		if _ic_to_spare >= ic_supply_need{
			_ic_to_spare -= ic_supply_need;
			ic_in_supply = ic_supply_need;
		}else{
			ic_in_supply = _ic_to_spare;
			_ic_to_spare -= ic_in_supply;
		}
		
		if _ic_to_spare >= ic_reinforce_need and ic_reinforce_need != 0{
			var _reinforce = round(ic_reinforce_need);
			switch (_reinforce){
				case 0:
				ic_in_reinforce = 1;
				_ic_to_spare--;
				break;
				case 1:
				ic_in_reinforce = 1;
				_ic_to_spare--;
				break;
				default:
				ic_in_reinforce = _ic_to_spare;
				_ic_to_spare -= ic_in_reinforce;
				break;
			}
		}else if _ic_to_spare < ic_reinforce_need{
			ic_in_reinforce = _ic_to_spare;
			_ic_to_spare = 0;
		}
		ic_in_production = _ic_to_spare;
		#endregion
		
		#region// Build items
		if ic_in_production > ic_production_need{//ai has ic to spare
			_ic_to_spare = ic_in_production - ic_production_need;
			var _supply_to_add = 0;
			while (_ic_to_spare > 0){
				if ic_supply_need < max_ic-(global.bal_ic_vs_unit+_prov_count/10)-_supply_to_add and mp > 15000{
					_lis_size = ds_list_size(units_unlocked);
					var _units_to_spawn_list = ds_list_create(),
						_units_to_spawn = -1;
					for (var i = 0; i < _lis_size; i++){// check for units available
						if units_unlocked[| i] == true{// if unit unlocked add to list to choose from
							_units_to_spawn++;
							ds_list_add(_units_to_spawn_list, i+unit_types);
						}
					}
					var _type = string(_units_to_spawn_list[| irandom_range(0, _units_to_spawn)]),
						_u = global.unit_data[? _type];
					mp -= _u[? "mp"];
					if ds_list_size(production_list) == 0 ds_list_add(production_list, _type + "," + capital + "," + _u[? "ic"] + "," + string(real(_u[? "d"])-unit_build_time_mod) + "," + string(real(_u[? "d"])-unit_build_time_mod));// add unit to que
					else ds_list_insert(production_list, ds_list_size(production_list), _type + "," + capital + "," + _u[? "ic"] + "," + string(real(_u[? "d"])-unit_build_time_mod) + "," + string(real(_u[? "d"])-unit_build_time_mod));// add unit to que
					
					_ic_to_spare -= _u[? "ic"];
					
				}else if _money_change > global.bal_build_ic{
					var _ic_build_time = string(global.build_ic_d - unit_build_time_mod);
					if ds_list_size(production_list) == 0 ds_list_add(production_list, "IC," + string(_prov_lis[| irandom_range(0, _prov_count-1)]) + "," + global.build_ic_ic + "," + _ic_build_time + "," + _ic_build_time);// add ic to que
					else ds_list_insert(production_list, ds_list_size(production_list), "IC," + string(_prov_lis[| irandom_range(0, _prov_count-1)]) + "," + global.build_ic_ic + "," + _ic_build_time + "," + _ic_build_time);// add ic to que
					_ic_to_spare -= global.build_ic_ic;
				}else{
					_ic_to_spare = 0;
				}
			}//end of while _ic_to_spare
		}
		#endregion
		
		#region// PEACE TIME TROOP MOVEMENTS
		if ds_list_size(at_war_with) == 0 and ai_last_power != ds_map_size(units){// PEACE TIME AI
			var _lis_size = ds_list_size(_prov_lis),
				_ai_unit_power = ds_map_size(units),
				_ai_prov_value_list = ds_list_create(),
				_sort_list = ds_list_create();
			ai_last_power = _ai_unit_power;
			for (var i = 0; i < _lis_size; i++){
				var _prov_id = global.province_id_list[? _prov_lis[| i]],
					_lis = global.data[? _prov_id.tile_id][? "path"],
					_lis_size2 = ds_list_size(_lis),
					_prov_value = round(_prov_id.ic/2);
				for (var i2 = 0; i2 < _lis_size2; i2++){
					var _prov_id2 = global.province_id_list[? _lis[| i2]];
					if _prov_id2.owner != _name{
						_prov_value += ds_list_size(_prov_id2.units_list);
						_prov_value += 1;
					}
				}
				ds_list_add(_sort_list, _prov_value);
				ds_list_sort(_sort_list, false);
				var _index = ds_list_find_index(_sort_list, _prov_value);
				if _index <= _lis_size/2 ds_list_insert(_ai_prov_value_list, _index, _prov_id.tile_id);
			}// end of loop to get list of prov values in order
			
			
			var _lis_size = ds_map_size(units),
				_key = ds_map_find_first(units),
				_loop_len = ds_list_size(_ai_prov_value_list),
				i2 = 0;
			show_debug_message("MOVING UNITS TO PROV " + string(_lis_size));
			for (var i = 0; i < _lis_size; i++){// send units to new provinces
				var _u = units[? _key];
				if _u[| 4] == 0{// Do not search path if in deploy pool
				if i2 >= _loop_len i2 = 0;// if more units than provinces start looping trough provs again
				
				

				if _u[| 5] == undefined and ds_list_find_index(deserting_units_list, _key) == -1{// dont move if doing so already
				
				if _u[| 5] != undefined ds_list_destroy(_u[| 5]);
				
				var _u_prov_tile = get_unit_tile_id(_key, _name),
					_unit_prov_id = global.province_id_list[?_u_prov_tile];
				
				
				show_debug_message(_u_prov_tile);
				show_debug_message(_ai_prov_value_list[| i2] + "  " + _name);
				
				ds_list_replace(_u, 5, get_path_to_province(_u_prov_tile, _ai_prov_value_list[| i2], at_war_with, _name));// add path to unit
				
				var _path = _u[| 5];
				
				if !is_undefined(_path){// CHECK IF PATH FROM FUNCTION IS VALID
					
									
					_path = _path[| 0];
					var _index = global.province_id_list[? _path];
					
					if _path != "-,-"{
						unit_move_delete(_unit_prov_id, _key);// check if unit already moving
						unit_move_add(_unit_prov_id, _index, _key)
					}else{
						ds_list_destroy(_u[| 5]);
					}
				}
				}//end of if has path
				_key = ds_map_find_next(units, _key);
				i2++;
				}// end of if in deploy pool
			}// end of for loop trough units
			
			
			
		}
		
		
		
		var	_lis_size = ds_list_size(at_war_with);// ai checks if it owns the capital and annexes
		for (var i = 0; i < _lis_size; i++){
			
			show_debug_message(_name);
			show_debug_message(at_war_with[| i]);
			show_debug_message(_lis_size);
			show_debug_message(i);
			
			var	_at_war_with_name = at_war_with[| i],
				_s_o_id = global.faction_id_map[? _at_war_with_name],
				_capital = _s_o_id.capital;
			if global.province_id_list[? _capital].owner == _name{
				var _my_id = id;
					with (oMapTileParent){
						if owner == _s_o_id._name{//annex province
							ds_list_clear(units_list);
							ds_list_clear(distance_list);
							ds_list_clear(moving_units_list);
							ds_list_clear(move_to_list);
							owner = _my_id._name;
							move_to = 0;// if adding allies later this will result in a crash
						}
						if og_owner == _s_o_id._name og_owner = owner;
					}
					ds_list_insert(oInGameMenu.log_list, 0, _name + " annexed " + _s_o_id._name + "!");
					instance_destroy(_s_o_id);//destroy the country obj
					ds_list_delete(at_war_with, ds_list_find_index(at_war_with, _at_war_with_name));
					remove_undefined(at_war_with);
					//show_message(_at_war_with_name + " ANNEXED");
					//if global.player == _at_war_with_name global.player = _name;// Player hops to play as annexer
					break;// ONLY ANNEX 1 PER DAY
			}
		}
		
		#endregion
		
		// AI DIPLOMACY
		if my_month != global.month_index{// Create new list of relevant countries once a month
			my_month = global.month_index;
			
			ds_priority_clear(relations_priority);
			var _my_id = id;
			
			with (oCountry) if _my_id != id and _name != global.player or _my_id != id and global.can_attack_player{// Ai cannot declare war to player
				
				if get_path_to_province_CHECK(capital, _my_id.capital, _name, _my_id._name){// CHECK IF COUNTRY HAS A PATH TO ONE ANOTHER
				
					var _value = ds_map_size(_my_id.units) + ds_list_size(_my_id.at_war_with)*global.bal_ai_at_war_with_weight - ds_map_size(units) - ds_list_size(at_war_with)*global.bal_ai_at_war_with_weight;
					// WHEN FACTIONS ARE IMPLEMENTED MAKE A DATA SHEET THAT SETS THE DEFAULT DIPLOMACY VALUES ACORDING TO FATION RELATIONS
					ds_priority_add(_my_id.relations_priority, _name, _value);
				}
			}
			
		}// end of if global month
		
		if ds_priority_size(relations_priority) > 0{
			if !is_undefined(ds_map_find_value(global.faction_id_map, ds_priority_find_max(relations_priority))){
				var _move_chance = ds_priority_find_priority(relations_priority, ds_priority_find_max(relations_priority));
				if _move_chance > global.bal_ai_war_declare_stresshold{// If chance for war
					_move_chance = irandom_range(0, _move_chance-global.bal_war_chance);
					if _move_chance > global.bal_ai_war_declare_stresshold declare_war(id, global.faction_id_map[? ds_priority_find_max(relations_priority)]);
				}
			}else{
				ds_priority_delete_max(relations_priority);// Faction no longer exists
			}
		}
		
		
		if ds_list_size(at_war_with) != 0 and peace_offered_timer <= 0{// WAR TIME DIPLOMACY
			var _lis_size = ds_list_size(at_war_with),
				_my_pow = ds_map_size(units)+global.bal_offer_peace_offset,
				_enemy_pows = 0;
			for (var i = 0; i < _lis_size; i++){
				var _country_id = global.faction_id_map[? at_war_with[| i]];
				_enemy_pows += ds_map_size(_country_id.units);
			
			}// End of for loop trough at_war_with
			if _my_pow < _enemy_pows{
				var _offer_peace_to = at_war_with[| choose(0, _lis_size-1)];
				if global.player == _offer_peace_to{// OFFER PEACE TO PLAYER
					//show_message("PEACE OFFER")
					ds_list_insert(global.events, 0, tomorrow() + "," + global.player + ",0,ummm... PEACE PLOX? t.&" + _name + "& :DDD,Sure,1,gitgud,0")
				}else{// OFFER PEACE TO AI
					var _accept = false;
					
					// Will decline by default
					
					if _accept make_peace(id, global.faction_id_map[? _offer_peace_to]);// Ai offers white peace
				}
				peace_offered_timer = irandom_range(5, 20);// AI can make new offer after X days
			}
		}else{
			peace_offered_timer--;
		}
		
	}//end of if ai
	
}// end of if my_h




if ai{
	if my_h != global.hour and ds_list_size(at_war_with) != 0{// WAR TIME AI
	my_h = global.hour;
	
	/*
	Collect data for prov values
	
	Collect value for bordering enemy provs
	
	Collect defensive value
	
	Collect strenght estimate of own units
	
	Check if can take empty provs
	
	Check if units can invade weak enemy prov
	*/
	
	#region// COLLECT VALUES FOR PROVINCES / LIST OF OWN AND LIST OF BORDERING HOSTILE ONES
	var _lis_size = global.prov_amount,
		_prov_priority = ds_list_create(),
		_prov_priority_values = ds_list_create(),
		_hostile_provinces_priority = ds_priority_create(),
		_ai_battle_power_map = ds_map_create(),
		_country_id = id;
	with (oMapTileParent){// loop trough all owned provinces
		
			
		if owner == _country_id._name{// if ai owns province
			
		var	_prov_value = 0,
			_path_lis = global.data[? tile_id][? "path"],
			_paths = ds_list_size(_path_lis);
		
		//_prov_value += ic;
		_prov_value -= ds_list_size(units_list)*global.bal_units_in_prov;
		
		for (var i2 = 0; i2 < _paths; i2++){// loop trough all the paths to province
			if ds_list_find_index(_country_id.at_war_with, global.province_id_list[? _path_lis[| i2]].owner) != -1{// at war with prov owner
				var _id = global.province_id_list[? _path_lis[| i2]],
					_value = ds_list_size(_id.units_list);
				
				// enemy units and connected enemy tiles increase provs ai value
				_prov_value += _value*global.bal_enemy_units_in_prov;
				_prov_value += global.bal_enemy_prov_next_to_own_value;
				
				ds_priority_add(_hostile_provinces_priority, _id.tile_id, _value);
				
				if is_undefined(ds_map_find_value(_ai_battle_power_map, tile_id)){// AIs border prov not yet in map
					var _units = ds_list_size(units_list),
						_unit_strenght = 0;
					for (var i3 = 0; i3 < _units; i3++){// loop trough units to get attack strenght estimate
						var _u = _country_id.units[? units_list[| i3]];
							_unit_strenght += _u[| 7] + _u[| 9] + _u[| 13]/5;
					}
					
					ds_map_add(_ai_battle_power_map, tile_id, _unit_strenght);
					
				}
			}
		}
		ds_list_add(_prov_priority, tile_id);
		ds_list_add(_prov_priority_values, _prov_value);
		}
	}// end of for loop trough owned provinces
	
	
	#endregion
	
	#region// WAR TIME UNIT MOVE
	
	var _key = ds_map_find_first(_ai_battle_power_map),
		_lis_size = ds_map_size(_ai_battle_power_map),
		_unit_power,
		_attack_target_prov = ds_map_create(),// attacker map (unit name + target prov)
		_defending_units = ds_list_create();
	
	for (var i = 0; i < _lis_size; i++){// loop provinces that are in enemy contact
		
		_unit_power = ds_map_find_value(_ai_battle_power_map, _key);
		_prov_id = global.province_id_list[? _key];
		
		if _unit_power != 0{
			// loop trough paths to find weakest target
			var _lis = global.data[? _key][? "path"],
				_lis_len = ds_list_size(_lis),
				_max_attack_targets = round(_unit_power/global.bal_attack_to_prov_stresshold);// add +1 for always ttack mode
			
			for (var i2 = 0; i2 < _lis_len; i2++){// loop trough paths
				var _border_id = global.province_id_list[? _lis[| i2]];
				if ds_list_find_index(at_war_with, _border_id.owner) != -1{// at war with border prov
					var	_units_list = _border_id.units_list,
						_units = ds_list_size(_units_list),
						_border_owner_id = global.faction_id_map[? _border_id.owner],
						_enemy_defend_value = 0;
						
						for (var i3 = 0; i3 < _units; i3++){// loop trough enemy units that are in border prov
							var _u = _border_owner_id.units[? _border_id.units_list[| i3]];
							_enemy_defend_value += _u[| 8] + _u[| 10] + _u[| 13]/5;
						}
						
						if _max_attack_targets > 0 and _enemy_defend_value <= _unit_power{// attack?
							/*
							send all units to attack in one prov if enough org
							refactor to accomidate for _max_attack targets
							*/
							
							//_max_attack_targets--;
							var	_units = ds_list_size(_prov_id.units_list);
							for (var i3 = 0; i3 < _units; i3++){// loop trough units in prov and add to attack map (add org check here)
								if units[? _prov_id.units_list[| i3]][| 13] > global.bal_org_to_attack_stresshold{
									ds_map_add(_attack_target_prov, _prov_id.units_list[| i3], _key + "," + _border_id.tile_id);
									
								}else{
									ds_list_add(_defending_units, _prov_id.units_list[| i3]);// no more attack tergets, unit defends prov
								}
							
							}
							}
							
							
					
						//_attack_to = ds_priority_find_min(_hostile_provinces_priority);
					
					
					
					//ds_list_add(_attack_target_prov, ds_priority_find_min(_hostile_provinces_priority));
					
					
					// Set units in prov to attack or add their names to defending units list
					
					
					
				}
			}// end of for loop trough paths
			
		}
		
		_key = ds_map_find_next(_ai_battle_power_map, _key);
	}
	
	
	
	var _key = ds_map_find_first(units),
		_lis_size = ds_map_size(units);
	for (var i = 0; i < _lis_size; i++){// LOOP TROUGH UNITS to adjust for where they are moving
		var _u = units[? _key][| 5];
		if _u != undefined{// unit has path
			_u = _u[| ds_list_size(_u)-1];
			var _index = ds_list_find_index(_prov_priority, _u);
			
			if _index != -1 ds_list_replace(_prov_priority_values, _index, _prov_priority_values[| _index]-global.bal_unit_moving_to_prov_weight);
			
		}
		_key = ds_map_find_next(units, _key);
	}
	
	
	// LOOP TROUGH UNITS
	_key = ds_map_find_first(units);
	
	show_debug_message(_name);
	for (var i = 0; i < _lis_size; i++){// loop trough units
		show_debug_message(_key);
		show_debug_message("loop: " + string(i));
		
		var _unit_state = 0,
			_u = units[? _key],
			_prov_id = get_unit_tile_id(_key, _name);
		
		show_debug_message(_prov_id);
		
		
		if _prov_id != undefined and _u[| 15] != 2 and _u[| 4] == 0{// is undefined if units are fleeing or if status is 2 they are pinned
			_prov_id = global.province_id_list[? _prov_id];
		
		if ds_list_find_index(_prov_id.moving_units_list, _key) == -1{
		
		
		if _u[| 5] == undefined and ds_list_find_index(_defending_units, _key) == -1{// unit is not moving or defending
			
			if ds_map_find_value(_attack_target_prov, _key) != undefined{// unit has plan to attack
				var	_prov_data = _attack_target_prov[? _key],
					_target_prov = global.province_id_list[? pos_split(_prov_data, 1)],
					_target_prov_id = global.province_id_list[? pos_split(_prov_data, 0)];
				
				unit_move_add(_target_prov_id, _target_prov, _key);
				
			}
			
			
		}
		if _u[| 5] == undefined and ds_list_find_index(_defending_units, _key) == -1 and ds_list_find_index(deserting_units_list, _key) == -1{// SEND UNIT TO WALK ON HIGHEST VALUE PROV
		
				
			var _u_prov_tile = get_unit_tile_id(_key, _name),
				_unit_prov_id = global.province_id_list[? _u_prov_tile];
			
			var _u_target_tile = "",
				_last_value = -99999,
				_lis_len = ds_list_size(_prov_priority);
			for (var i2 = 0; i2 < _lis_len; i2++){
				var _priority_tile = _prov_priority[| i2],
					_prov_id = global.province_id_list[? _priority_tile],
					_value = _prov_priority_values[| i2]-round(point_distance(_prov_id.my_x, _prov_id.my_y, _unit_prov_id.my_x, _unit_prov_id.my_y)/global.bal_unit_distance_to_prov_weight);// unit distace to prov affects it's value
				if _last_value < _value{
					_u_target_tile = _priority_tile;
					_last_value = _value;
				}
			}
			ds_list_replace(_prov_priority_values, ds_list_find_index(_prov_priority, _u_target_tile), _prov_priority_values[| ds_list_find_index(_prov_priority, _u_target_tile)]-global.bal_unit_moving_to_prov_weight)// reduce targetet provs value
			
			
			
			ds_list_replace(_u, 5, get_path_to_province(_u_prov_tile, _u_target_tile, at_war_with, _name));// add path to unit
			
			var _path = _u[| 5];
			
			
			
				if !is_undefined(_path){// CHECK IF PATH FROM FUNCTION IS VALID
									
					_path = _path[| 0];
					show_debug_message(_path);
					show_debug_message(typeof(_path));
						var _index = global.province_id_list[? _path];

						if ds_list_find_index(_unit_prov_id.moving_units_list, _key) != -1 unit_move_delete(_unit_prov_id, _key);// check if unit already moving
						unit_move_add(_unit_prov_id, _index, _key);// add unit to move
				}
				
		}
		
		
		switch (_unit_state){// state machine to asign units action
			
			case 0:
			
			break;
			
		}
		
		} // end of if fleeing
		}// end of if moving
		
		
		_key = ds_map_find_next(units, _key);
	}// end of loop trough units
	

	
	#endregion
	}//end of if global.hour
	
	if _d_change{
		_key = ds_map_find_first(units);
		_lis_size = ds_map_size(units);
		for (var i = 0; i < _lis_size; i++){
			units[? _key][| 15] = 0;
			_key = ds_map_find_next(units, _key);
		}
	}
}
