#region // DRAW TOP AND BOTTOM BARS
var results = 0,
	p_id =  global.faction_id_map[? global.player],
	_b_color = global.colors[? global.player];
global.menu_box_x_offset = 0;
draw_set_font(font_basic);

draw_sprite_ext(s9Slice, 1, 0, 759, 11, 3, 0, _b_color, 1);//bottom background

draw_set_color(c_gray);


draw_rectangle(0, 0, 2000, 34, false);// top bad underline
draw_sprite_ext(s9Slice, 1, 700, -89, 11, 1, 0, _b_color, 1);

draw_set_color(c_dkgray);
draw_rectangle(1308, 740, 1388, 1080, false);// map mode base
draw_rectangle(0, 735, 1920, 739, false);


var _x = 1316,
	_y = 739;
// MAP MODE BUTTONS
for (var i = 0; i < 5; i++){
	results = button_detect(_x, _y, sMapMode, 0);
	button_draw_mapmode(i, results, sMapMode, 0, _x, _y);
	if results == 2 global.map_mode = i;
	_y += 68;
}

draw_sprite_ext(s9Slice, 0, 600, 800, 5.2, 2, 0, c_white, 1);// DRAW EVENT LOG
var _lis_size = ds_list_size(log_list),
	_y = 0;
if _lis_size > 11{// clean old log entries
	repeat (_lis_size-11){
		ds_list_delete(log_list, -1);
	}
	_lis_size = 11;
}
draw_set_font(font_basic_small);
draw_set_color(c_white);
for (var i = 0; i < _lis_size; i++){// draw log
	
	draw_text(610, 810+_y, log_list[| i]);
	
	_y += 20;
}
draw_set_font(font_basic);


if global.prov_menu != ""{
	var _id = global.prov_menu,
		o_id = global.faction_id_map[? _id.owner];
	draw_set_color(c_white);
	if _id.units_selected != -1 and ds_list_size(_id.units_list) > 0{//show selected unit data
		var _unit_data = _id.units_list[| _id.units_selected],
			_unit_state = "Idle";
		
		draw_text(100, 760, _unit_data);
		
		var _unit_data_list = o_id.units[? _unit_data];
		
		results = button_detect(40, 800, sUnitsBig, _unit_data_list[| 1]);
		button_draw(results, sUnitsBig,_unit_data_list[| 1], 40, 800);
		if results == 2{
			button_pressed = 2;
			last_selected_unit = _unit_data;
		}
	
		if ds_list_find_index(_id.moving_units_list, _unit_data) != -1{// unit moving
			_unit_state = "Moving";
			draw_text(100, 990, "Distance: " + string(_id.distance_list[| ds_list_find_index(_id.moving_units_list, _unit_data)]));
			if _unit_data_list[| 5] != undefined draw_text(100, 1020, "On a path to: " + string(global.province_id_list[? _unit_data_list[| 5][| ds_list_size(_unit_data_list[| 5])-1]]._name));
			
		}
		draw_text(100, 960, _unit_state);
		draw_text(100, 1050, _unit_data_list[| 15]);
			
		
	}else{// show selected PROV data
		draw_text(100, 760, _id._name);
		var _terrain_index = get_prov_image_index(_id.ter, _id.tile_id);
		results = button_detect(100, 800, sTerrains, _terrain_index);
		button_draw(results, sTerrains, _terrain_index, 100, 800);
		if results == 2 button_pressed = 1;
		
		draw_text(100, 920, "IC: " + string(_id.ic) + "/" + string(_id.max_ic));
		draw_text(100, 945, "Pop: " + round_number_to_string(_id.pop));
		draw_text(100, 970, "Wealth: " + string(_id.wealth));
		draw_text(100, 995, "WP: " + string(_id.wp));
		
		if _id.owner == global.player{// players prov options
			
			results = button_detect(250, 925, sIC, 0);
			button_draw(results, sIC, 0, 250, 925);//build ic button
			var _ic_build_time = string(global.build_ic_d - p_id.ic_build_time_mod);
			if results == 2 and ds_list_size(p_id.production_list) == 0 ds_list_add(p_id.production_list, "IC," + _id.tile_id + "," + global.build_ic_ic + "," + _ic_build_time + "," + _ic_build_time);// add ic to que
			else if results == 2 ds_list_insert(p_id.production_list, ds_list_size(p_id.production_list), "IC," + _id.tile_id + "," + global.build_ic_ic + "," + _ic_build_time + "," + _ic_build_time);// add ic to que
		
			if p_id.scortched_earth{//scorch earth button (add different sprites)
				results = button_detect(290, 925, sIC, 1);
				button_draw(results, sIC, 1, 290, 925);
				if results == 2 p_id.scortched_earth = false;
			}else{
				results = button_detect(290, 925, sIC, 2);
				button_draw(results, sIC, 2, 290, 925);
				if results == 2 p_id.scortched_earth = true;
			}
		}
	}
	
	
	draw_text(370, 760, _id.owner);
	
	if _id.owner != _id.og_owner{// Check if province occupied by foreing power
		var _og_owner_id = global.faction_id_map[? _id.og_owner],
			_sprite_height = sprite_get_height(sFlagsP1),
			_prite_width = sprite_get_width(sFlagsP1)/2,
			_cutoff_x = 370+_prite_width;
			
		results = button_detect_area(_cutoff_x, 800, _cutoff_x+_prite_width, 800+_sprite_height, 0);
		button_draw_part(results, sFlagsP1, _og_owner_id.flag, 370+_prite_width, 800, _prite_width, _sprite_height, _prite_width, 0);
		if results == 2{
			button_pressed = 0;
			country_to_view = _og_owner_id._name;
		}
			
		results = button_detect_area(370, 800, _cutoff_x, 800+_sprite_height, 0);
		button_draw_part(results, sFlagsP1, o_id.flag, 370, 800, _prite_width, _sprite_height, 0, 0);
		if results == 2{
			button_pressed = 0;
			country_to_view = o_id._name;
		}
	}else{// not occupied
		results = button_detect(370, 800, sFlagsP1, 0);
		button_draw(results, sFlagsP1, o_id.flag, 370, 800);
		if results == 2{
			button_pressed = 0;
			country_to_view = o_id._name;
		}
	}
}
#endregion


draw_set_color(c_white);
switch (button_pressed){
	case 0:
	#region//		COUNTRY DATA MENU
	draw_sprite_ext(Sprite45, 0, 0, 0, 2.333333333333333, 3.3, 0, _b_color, 1);
	//draw_sprite_ext(s9Slice, 0, 40, 100, 5, 5.2, 0, c_white, 1);
	
	var _x = 500,
		_y = 200,
		o_id;

	o_id = global.faction_id_map[? country_to_view];
	if o_id == undefined o_id = p_id;
	
	if o_id == p_id{
		with (oCountry){// get owned capitals
			show_debug_message(global.province_id_list[? capital].owner);
			if id != p_id and global.province_id_list[? capital].owner == global.player{// player owns enemy capital
				results = button_detect(_x, _y, sFlagsP1, flag);
				button_draw(results, sFlagsP1, flag, _x, _y);
				if results == 2{
					var _s_o_id = id;
					with (oMapTileParent){
						if owner == _s_o_id._name{//annex province
							ds_list_clear(units_list);
							ds_list_clear(distance_list);
							ds_list_clear(moving_units_list);
							ds_list_clear(move_to_list);
							owner = p_id._name;
							move_to = 0;// if adding allies later this will result in a crash
						}
						if og_owner == _s_o_id._name og_owner = owner;
					}
					ds_list_insert(oInGameMenu.log_list, 0, p_id._name + " annexed " + id._name + "!");
					instance_destroy(id);//destroy the country obj
				}
				_y += 140;
			}
		}
	}else{// country is not player == show diplomacy options
		var _x = 500,
			_y = 400;
		
		results = button_detect(_x, _y, sExitMenu, 0);
		button_draw(results, sExitMenu, 0, _x, _y);
		if results == 2 declare_war(p_id, o_id);
		draw_text(_x+5, _y+10, "WAR");
		_y += 50;
		results = button_detect(_x, _y, sExitMenu, 0);
		button_draw(results, sExitMenu, 0, _x, _y);
		if results == 2 make_peace(p_id, o_id);
		draw_text(_x+5, _y+10, "0 PEACE");
		_y += 50;
		results = button_detect(_x, _y, sExitMenu, 0);
		button_draw(results, sExitMenu, 0, _x, _y);
		if results == 2 make_peace(p_id, o_id, 1);
		draw_text(_x+5, _y+10, "1 PEACE");
		
	}
	
	_x = 150;
	
	draw_text(_x,  200, o_id._name);
	var _pop_str = "Population: " + round_number_to_string(o_id.total_pop);
	draw_text(_x,  230, _pop_str);
	var _xoffset = 10+string_width(_pop_str);
	draw_text(_x+_xoffset, 230, " (");
	_xoffset += string_width(" (");
	_pop_str = o_id.total_pop - o_id.total_pop_last_turn;
	get_string_color(_pop_str);
	_pop_str = string(_pop_str);
	draw_text(_x+_xoffset, 230, _pop_str);
	draw_set_color(c_white);
	draw_text(_x+_xoffset+string_width(_pop_str), 230, ")");
	draw_text(_x,  260, "Taken casualties: " + string(o_id.taken_cas));
	draw_text(_x,  290, "Inflicted casualties: " + string(o_id.inflicted_cas));
	
	
	// draw leaders here
	var _sprite = global.country_leader_map[? o_id._name],
		_x = 0,
		_y = 0;
	// ADD LEADER NAMES AND EFFECT TYPES TO JSON (effect types are INTs that lead to a global list/map of effects)
	draw_sprite(_sprite, 0, 150, 350);
	#endregion
	break;
	case 1:
	#region//		ECONOMY MENU
	draw_sprite_ext(Sprite45, 0, 0, 0, 2.333333333333333, 3.3, 0, _b_color, 1);
	draw_sprite_ext(s9Slice, 0, 40, 100, 5, 5.2, 0, c_white, 1);
	
	var _x = 85,
		xoffset = sprite_get_width(sSliderBase)+30,
		_y = 180,
		yoffset = 0,
		yoffadd = 90,
		ic_left_to_use = p_id.total_ic;

	draw_set_color(c_green);
	draw_text(_x+xoffset, _y-60, "Administration cost: " + string(round(p_id.administration_cost*100)) + "%");
	draw_set_color(c_white);
	
	
	//tax %
	p_id.tax_lvl = slider_create(_x, _y+yoffset, sSliderBase, sSliderButton, p_id.tax_lvl, 100, "TAX %");
	draw_text(_x+xoffset, _y+yoffset-15, string(p_id.tax_lvl) + "% (" + string(p_id.money_last_turn) + ")");
	yoffset += yoffadd;
	
	//funding
	p_id.ic_funding = slider_create(_x, _y+yoffset, sSliderBase, sSliderButton, p_id.ic_funding, 100, "IC Funding");
	draw_text(_x+xoffset, _y+yoffset-15, string(p_id.ic_funding) + "% (" + string(p_id.total_ic) + "/" + string(p_id.max_ic) + ")");
	yoffset += yoffadd;
	
	//production
	p_id.ic_in_production = slider_create(_x, _y+yoffset, sSliderBase, sSliderButton, p_id.ic_in_production, ic_left_to_use, "Production");
	ic_left_to_use -= p_id.ic_in_production;
	draw_text(_x+xoffset, _y+yoffset-15, string(p_id.ic_in_production) + "/" + string(p_id.ic_production_need));
	yoffset += yoffadd;
	
	//supplies
	p_id.ic_in_supply = slider_create(_x, _y+yoffset, sSliderBase, sSliderButton, p_id.ic_in_supply, ic_left_to_use, "Supplies");
	ic_left_to_use -= p_id.ic_in_supply;
	draw_text(_x+xoffset, _y+yoffset-15, string(p_id.ic_in_supply) + "/" + string(p_id.ic_supply_need));
	yoffset += yoffadd;
	
	//reinforcements
	p_id.ic_in_reinforce = slider_create(_x, _y+yoffset, sSliderBase, sSliderButton, p_id.ic_in_reinforce, ic_left_to_use, "Reinforcements");
	ic_left_to_use -= p_id.ic_in_reinforce;
	draw_text(_x+xoffset, _y+yoffset-15, string(p_id.ic_in_reinforce) + "/" + string(p_id.ic_reinforce_need));
	yoffset += yoffadd;
	
	//mob lvl
	p_id.mob_lvl = slider_create(_x, _y+yoffset, sSliderBase, sSliderButton, p_id.mob_lvl, 4, "Mobilization Level");
	draw_text(_x+xoffset, _y+yoffset-15, global.moblization_name_list[| p_id.mob_lvl]);
	#endregion
	break;
	case 2:
	#region//		UNIT MENU
	draw_sprite_ext(Sprite45, 0, 0, 0, 2.333333333333333, 3.3, 0, _b_color, 1);
	draw_sprite_ext(s9Slice, 0, 40, 100, 5, 5.2, 0, c_white, 1);
	
	//draw unit attributes here
	if ds_map_size(p_id.units) > 0{
		// display selected unit if exists else use first in map
		if last_selected_unit != -1 and p_id.units[? last_selected_unit] != undefined{
			var _name = last_selected_unit,
				_unit = p_id.units[? last_selected_unit];
		}else{
			var _name = ds_map_find_first(p_id.units),
				_unit = p_id.units[? _name];
			last_selected_unit = ds_map_find_first(p_id.units);
		}
		
		var	_x = 90,
			_y = 160;
		draw_text(_x, _y-30, _name);
		for (var i = 0; i < 14; i++){
			switch (i){
				case 0:
				var _info = "Type: ";
				break;
				case 1:
				var _info = "Sprite: ";
				break;
				case 2:
				var _info = "MP: ";
				break;
				case 3:
				var _info = "SPD: ";
				break;
				case 4:
				var _info = "In deploy pool: ";
				break;
				case 5:
				var _info = "Path: ";
				break;
				case 6:
				var _info = "Supply consumption: ";
				break;
				case 7:
				var _info = "Atk: ";
				break;
				case 8:
				var _info = "Def: ";
				break;
				case 9:
				var _info = "Hard atk: ";
				break;
				case 10:
				var _info = "Toughness: ";
				break;
				case 11:
				var _info = "Terrain profile: (not shown to player) ";
				break;
				case 12:
				var _info = "Morale: ";
				break;
				case 13:
				var _info = "Organization: ";
				break;
			}
			
			
			draw_text(_x, _y, _info + string(_unit[| i]));
			_y += 30;
		}
		
		_y += 30;
		draw_text(_x, _y, "Units total: " + string(ds_map_size(p_id.units)));
		var _lis_size = ds_map_size(p_id.units),
			_key = ds_map_find_first(p_id.units),
			_total_mp = 0;
		for (var i = 0; i < _lis_size; i++){
			_total_mp += p_id.units[? _key][| 2];
			_key  = ds_map_find_next(p_id.units, _key);
		}
		_y += 30;
		draw_text(_x, _y, "Total army strenght: " + string(_total_mp));
		
		//draw unit selection
		draw_sprite_stretched(sUnits, _unit[| 1], 400, 200, 128, 128);
		
		if ds_map_find_first(p_id.units) != last_selected_unit{
			results = button_detect(350, 235, sArrow, 0);
			button_draw(results, sArrow, 0, 350, 235);
			if results == 2 last_selected_unit = ds_map_find_previous(p_id.units, last_selected_unit);
		}
		if ds_map_find_last(p_id.units) != last_selected_unit{
			results = button_detect(550, 235, sArrow, 1);
			button_draw(results, sArrow, 1, 550, 235);
			if results == 2 last_selected_unit = ds_map_find_next(p_id.units, last_selected_unit);
		}
		
		//draw unit disbantment
		if _unit[| 4] == 1{
			results = button_detect(500, 580, sExitMenu, 1);
			button_draw(results, sExitMenu, 1, 500, 580);
			if results == 2{
				p_id.mp += _unit[| 2];//return units mp to pool
				if _unit[| 5] != undefined ds_list_destroy(_unit[| 5]);
				if _unit[| 4] != 0{//unit in deploy pool
					ds_map_delete(p_id.units, _name);
				}
			}
		}// end of unit disbantment
		
	}else{// no units
		draw_text(150, 200, "No units");
	}
	#endregion
	break;
	case 3:
	#region//		TECH MENU
	if tech_display == -1 draw_sprite_ext(Sprite45, 0, 0, 0, 2.333333333333333, 3.3, 0, _b_color, 1);
	else{
		global.menu_box_x_offset = 400;
		draw_sprite_ext(Sprite45, 0, 0, 0, 3.666666666666667, 3.3, 0, _b_color, 1);
	}
	draw_sprite_ext(s9Slice, 0, 20, 64, 5.5, 5.5, 0, c_white, 1);
	
	//TECH FUNDING %
	p_id.research_funding = slider_create(50, 140, sSliderBase, sSliderButton, p_id.research_funding, 100, "Research funding %");
	draw_text(50+sprite_get_width(sSliderBase)+30,125, string(p_id.research_funding) + "% (" + string(p_id.research_cost) + ")");
	
	var _tech = p_id.tech_list,
		_cutoff = get_tech_cutoff(p_id);
	
	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_set_font(font_13);
	
	
	results = button_detect(600, 120, sCancelButton, 0);
	button_draw(results, sCancelButton, 0, 600, 120);
	if results == 2 and tech_tree != 2 tech_tree = 2;
	else if results == 2 tech_tree = 0;
	
	if tech_tree != 2{
	switch (tech_tree){
		case 0:// social tech
		var _lis_size = _cutoff;
		_cutoff = 0;
		draw_sprite(sCancelButton, 0, 500, 120);
		
		results = button_detect(550, 120, sCancelButton, 0);
		button_draw(results, sCancelButton, 0, 550, 120);
		if results == 2 tech_tree = 1;
		break;
		case 1:// warfare tech
		_lis_size = ds_list_size(_tech) - _cutoff;
		
		results = button_detect(500, 120, sCancelButton, 0);
		button_draw(results, sCancelButton, 0, 500, 120);
		if results == 2 tech_tree = 0;
		
		draw_sprite(sCancelButton, 0, 550, 120);
		break;
	
	}
	
	
	
	var _xoffset = sprite_get_width(sTechButton)/2,
		_yoffset = sprite_get_height(sTechButton);
	for (var i = 0; i < _lis_size; i++){// draw techs in list
		var _str = _tech[| i+_cutoff],
			_x = pos_split(_str, 0),
			_name = pos_split(_str, 1),
			_done = real(pos_split(_str, 2)),
		_y = real(dot_split(_x, 1));
		_x = real(dot_split(_x, 0));
		
		i++;
		var _needed_tech = _tech[| i+_cutoff];
		
		if _needed_tech != undefined{//draw tech line
			draw_set_color(c_white);
			var _old_cor = pos_split( _tech[| _needed_tech], 0);
			draw_line_width(real(dot_split(_old_cor, 0))+_xoffset, real(dot_split(_old_cor, 1))+_yoffset, _x+_xoffset, _y, 3);
			draw_set_color(c_black);
		}
		
		
		if _needed_tech == undefined or pos_split( _tech[| _needed_tech], 2) == "1" and _done == 0{// tech can be researched
			if _done != 1{
				results = button_detect(_x, _y, sTechButton, 0);
				button_draw(results, sTechButton, 0, _x, _y);
				button_draw_index(results, sTechButton, 0, _x, _y);
				if results == 2 tech_display = real(pos_split(_str, 3));
			}else{
				draw_sprite(sTechButton, 3, _x, _y);
			}
		}else if _done == 1{//tech done
			draw_sprite(sTechButton, 3, _x, _y);
		}else{//tech locked
			draw_sprite(sTechButton, 4, _x, _y);
		}
		
		draw_text(_x+_xoffset, _y+1, _name);
		

		
	}//end of draw _tech for loop
	draw_set_halign(fa_left);
	
	draw_titles(p_id.unit_types, tech_tree);
	
	if tech_display != -1{//display side menu and tech discription
		//draw_sprite_stretched(sMenuSecondLayer, 0, global.menu_box_x, 35, 400, 700);
		//draw_sprite_ext(s9Slice, 0, 740, 300, 2.66, 3.3, 0, c_white, 1);
		
		var _pos = 0;
		if tech_display != 0 _pos = tech_display*2;
		var _str = _tech[| _pos],
			_text = pos_split(_str, 4),
			_info = pos_split(_str, 5);
		
		draw_sprite(global.tech_sprite, _pos, 740, 80);
		
		draw_set_color(c_white);
		draw_text_ext(755, 320, _text, 30, 300);
		draw_text(755, 540, "Cost: " + string(round(real(dot_split(_info, 0))*p_id.tech_cost_mod)));
		_info = dot_split(_info, 1);
		draw_text(755, 570, "Time: " + string(round(real(string_delete(_info, string_length(_info)-1, 2))*p_id.tech_time_mod)) + " days");
	
		//back button
		results = button_detect(755, 660, sExitMenu, 0);
		button_draw(results, sExitMenu, 0, 755, 660);
		draw_text(760, 662, "Close");
		if results == 2 tech_display = -1;
		
		//check if selected tech already in research
		_lis_size = ds_list_size(p_id.tech_development_list);
		results = 0;
		for (var i = 0; i < _lis_size; i++){
			var _t = real(dot_split(p_id.tech_development_list[| i], 3));
			if _t == _pos{
				results = 1;// tech already in research
				var _t_pos = i;
			}
		}
		
		switch (results){
			case 0://can research
			results = button_detect(755, 610, sExitMenu, 0);
			button_draw(results, sExitMenu, 0, 755, 610);//develop tech
			draw_text(760, 612, "Research");
			if results == 2{
				var _tech_que = pos_split(_str, 5);
ds_list_add(p_id.tech_development_list, string(round(real(dot_split(_tech_que, 0))*p_id.tech_cost_mod)) + "&" + string(round(real(dot_split(_tech_que, 1))*p_id.tech_time_mod)) + "&" + string(round(real(dot_split(_tech_que, 1))*p_id.tech_time_mod)) + "&" + dot_split(_tech_que, 2));// cost + time + time + type
				tech_display = -1;
			}
			break;
			case 1://cancel research
			results = button_detect(755, 610, sExitMenu, 0);
			button_draw(results, sExitMenu, 0, 755, 610);
			draw_text(760, 612, "Cancel");
			if results == 2{//cancel research
				ds_list_delete(p_id.tech_development_list, _t_pos);
				tech_display = -1;
			}
			break;
		}
		
	}//end of if tech_display
	}else{// if tech_tree = 2 DRAW MODIFIERS
		draw_set_color(c_white);
		draw_set_font(font_18);
		draw_set_halign(fa_left);
		var _x = 70,
			_y = 200,
			_xoffset = 0,
			_str = "unit_org_reqroup_mod: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		get_string_color(p_id.unit_org_reqroup_mod);
		draw_as_percent(_x+_xoffset, _y, p_id.unit_org_reqroup_mod);
		draw_set_color(c_white);
		_y += 30;
		_str = "strategic_org_deploy_default: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		get_string_color(p_id.strategic_org_deploy_default, 50);
		draw_text(_x+_xoffset, _y, p_id.strategic_org_deploy_default);
		draw_set_color(c_white);
		_y += 30;
		_str = "org_recovery_rate: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		draw_set_color(c_yellow);
		draw_text(_x+_xoffset, _y, p_id.org_recovery_rate);
		draw_set_color(c_white);
		_y += 30;
		_str = "scortched_earth: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		get_string_color(p_id.scortched_earth, 0.5);
		if p_id.scortched_earth _str = "On"
		else _str = "Off"
		draw_text(_x+_xoffset, _y, _str);
		draw_set_color(c_white);
		_y += 30;
		_str = "unit_build_time_mod: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		draw_text(_x+_xoffset, _y, "-" + string(p_id.unit_build_time_mod) + " days");
		_y += 30;
		_str = "ic_build_time_mod: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		draw_text(_x+_xoffset, _y, "-" + string(p_id.ic_build_time_mod) + " days");
		_y += 30;
		_str = "administration_cost_mod: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		draw_text(_x+_xoffset, _y, string(p_id.administration_cost_mod));
		draw_text(_x, _y, _str);
		_y += 30;
		_str = "tech_cost_mod: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		get_string_color(p_id.tech_cost_mod);
		draw_as_percent(_x+_xoffset, _y, p_id.tech_cost_mod);
		draw_set_color(c_white);
		_y += 30;
		_str = "tech_time_mod: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		get_string_color(p_id.tech_time_mod);
		draw_as_percent(_x+_xoffset, _y, p_id.tech_time_mod);
		draw_set_color(c_white);
		_y += 30;
		_str = "wp_mdivider: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		draw_text(_x+_xoffset, _y, p_id.wp_mod);
		_y += 30;
		_str = "pop_growth_mod: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		get_string_color(p_id.pop_growth_mod);
		draw_as_percent(_x+_xoffset, _y, p_id.pop_growth_mod);
		draw_set_color(c_white);
		_y += 30;
		_str = "supply_consumption_mod: ";
		draw_text(_x, _y, _str);
		_xoffset = string_width(_str);
		get_string_color(p_id.supply_consumption_mod, 0.8, c_red, c_green);
		draw_as_percent(_x+_xoffset, _y, p_id.supply_consumption_mod);
		draw_set_color(c_white);
		

		// TERRAIN MODS
		_x = 460;
		_y = 200;
		draw_text(_x, _y, "Plains: " + string(p_id.plains_move_mod) + "/" + string(p_id.plains_combat_mod));
		_y += 30;
		draw_text(_x, _y, "Desert: " + string(p_id.desert_move_mod) + "/" + string(p_id.desert_combat_mod));
		_y += 30;
		draw_text(_x, _y, "Urban: " + string(p_id.urban_move_mod) + "/" + string(p_id.urban_combat_mod));
		_y += 30;
		draw_text(_x, _y, "Hills: " + string(p_id.hills_move_mod) + "/" + string(p_id.hills_combat_mod));
		_y += 30;
		draw_text(_x, _y, "Forest: " + string(p_id.forest_move_mod) + "/" + string(p_id.forest_combat_mod));
		_y += 30;
		draw_text(_x, _y, "Suburban: " + string(p_id.suburban_move_mod) + "/" + string(p_id.suburban_combat_mod));
	}
	#endregion
	break;
	case 4:
	#region//		UNIT DEPLOY
	draw_sprite_ext(Sprite45, 0, 0, 0, 2.333333333333333, 3.3, 0, _b_color, 1);
	
	var _lis_size = ds_map_size(p_id.units),
		_key = ds_map_find_first(p_id.units),
		_x = 40,
		_y = 0,
		_count = 0,
		_amount_to_show = 0;
		
	// vertival deploy slider
		deploy_slider = slider_create_vertical(_x-10, 160, sSliderBaseVertical, sSliderButtonVertical, deploy_slider, 100);
		var _amount_to_show = round((_lis_size-3)*(deploy_slider/100));
		
		
	for (var i = 0; i < _lis_size; i++){// loop trough all units
		var _unit = p_id.units[? _key],
			_in_depo = p_id.units[? _key][| 4];
		
		if _in_depo == 1 and i >= _amount_to_show{// unit can be deployed and is shown
			_count++;
			draw_text(_x, 200+_y, _key);
			_y += 30;
			results = button_detect(_x, 200+_y, sUnitsBig, 0);
			button_draw(results, sUnitsBig, 5, _x, 200+_y);
			if results == 2{// activate deployment here
				last_map_mode = global.map_mode;// store old map mode to reset after deploy
				global.map_mode = 2;
				unit_to_deploy = _key;
				with (oMapTileParent){// unselect all
					units_selected = -1;
					selected = false;
				}
			}
			_y += 150;
		}else if _in_depo == 2 and i >= _amount_to_show{// In deploy but cannot yet be deployed
			_count++;
			
			draw_sprite(_x, 200+_y, sUnitsBig, 5);
			_y += 30;
			draw_text(_x, 200+_y, "NOT YET READY");
			_y += 150;
			
		}
		if _count == 3 break;
		_key  = ds_map_find_next(p_id.units, _key);
	}// end of for loop trough all units
	
	// SHOW GLOBAL BATTLES (ADD VERTICAL SLIDER)
	_lis_size = ds_list_size(global.battles_list);
	_x = 400;
	_y = 180;
	for (var i = 0; i < _lis_size; i++){
		var _str = global.battles_list[| i],
			_info = pos_split(_str, 0),
			_balance = real(pos_split(_str, 1)),
			_attackers = pos_split(_str, 2),
			_defenders = pos_split(_str, 3);
		
		draw_text(_x, _y, dot_split(_info, 1));
		if dot_split(_info, 0) == "0"{// attacker is player
			_balance = _balance*50;
			if _balance > 100 _balance = 99;
			draw_healthbar(_x, _y+40, _x+120, _y+50, _balance, c_red, c_green, c_green, 0, true, false);
			draw_text(_x, _y+60, _attackers + " vs " + _defenders);
		}else{// defender is player
			_balance = _balance*50;
			if _balance > 100 _balance = 99;
			_balance = 100 -_balance;
			draw_healthbar(_x, _y+40, _x+120, _y+50, _balance, c_red, c_green, c_green, 0, true, false);
			draw_text(_x, _y+60, _defenders + " vs " + _attackers);
		}
		// view battle button
		results = button_detect(_x+85, _y+62, sCancelButton, 0);
		button_draw(results, sCancelButton, 0, _x+85, _y+62);
		if results == 2{// look at battle pos
			var _spot_id = tile_name_get_id(dot_split(_info, 1));
			oCamera.x = _spot_id.my_x;
			oCamera.y = _spot_id.my_y;
		}
		
		_y += 100;
	}
	
	#endregion
	break;
	case 5:
	#region//		PRODUCTION MENU
	if production_unit_display == -1 draw_sprite_ext(Sprite45, 0, 0, 0, 2.333333333333333, 3.3, 0, _b_color, 1);
	else{
		global.menu_box_x_offset = 400;
		draw_sprite_ext(Sprite45, 0, 0, 0, 3.666666666666667, 3.3, 0, _b_color, 1);
	}
	draw_sprite_ext(s9Slice, 0, 7, 100, 5.7, 5.2, 0, c_white, 1);
	
	// draw production que
	var _lis_size = ds_list_size(p_id.production_list),
		_x = 40,
		_y = 160,
		_amount_to_show = 0;
		
	// production que slider
	if _lis_size > 5{
		que_slider = slider_create_vertical(_x, 160, sSliderBaseVertical, sSliderButtonVertical, que_slider, 100);
		var _amount_to_show = round((_lis_size-5)*(que_slider/100));
		_lis_size = 5;//show max 5 at a time
	}
	_x += 40;
	for (var i = 0; i < _lis_size; i++){// draw items in production
		var _string = p_id.production_list[| i+_amount_to_show];
		if _string == undefined break;
		var	_name = global.province_id_list[? pos_split(_string, 1)],
			_switch = pos_split(_string, 0);
		switch (_switch){// check if item in production is unit then get name
			case "IC":
			draw_text(_x, _y, _name._name);
			break;
			default:
			draw_text(_x, _y, global.unit_data[? _switch][? "name"]);
			break;
		}
		
		_y += 30;
		var _str = "IC need: " + pos_split(_string, 2) + "  " + pos_split(_string, 3) + "/" + pos_split(_string, 4);
		draw_text(_x, _y, _str);
		_str = string_length(_str)*13;
		results = button_detect(_x+_str, _y+3, sCancelButton, 0);
		button_draw(results, sCancelButton, 0, _x+_str, _y+3);
		if results == 2 and _switch != "IC"{//cancel unit and return mp
			p_id.mp += global.unit_data[? _switch][? "mp"];
			ds_list_delete(p_id.production_list, i+_amount_to_show);
		}else if results == 2{ ds_list_delete(p_id.production_list, i+_amount_to_show);}//cancel contruction
		_y += 60;
	
	}
	
	
	// draw producable items (prov updates straight from prov menu)
	var _li_size = ds_list_size(p_id.units_unlocked),
		_lis_size = 0;
	for (var i = 0; i < _li_size; i++){
		if p_id.units_unlocked[| i] _lis_size++;
	}
	_x = 360;
	_y = 165;
	
	// unit production slider
	if _lis_size > 4{
		production_slider = slider_create_vertical(_x, _y, sSliderBaseVertical, sSliderButtonVertical, production_slider, 100);
		var _amount_to_show = round((_lis_size-4)*(production_slider/100));
		_lis_size = 4;//show max 4 at a time
	}
	_x += 40;
	draw_text(_x, _y, "Units");
	_y += 50;
	
	for (var i = 0; i < _lis_size; i++){
		if p_id.units_unlocked[| i+_amount_to_show]{
			
			results = button_detect(_x-5, _y-5, sProductionBackground, 0);
			button_draw(results, sProductionBackground, 0, _x-5, _y-5);// unit to produce selection
			if results == 2 production_unit_display = i+_amount_to_show;
			
			draw_set_color(c_white);
			var _unit_info = global.unit_data[? string(i+_amount_to_show)];
			draw_text(_x, _y, _unit_info[? "name"]);
			draw_text(_x, _y+30, "IC: " + _unit_info[? "ic"] + "    Time: " + string(real(_unit_info[? "d"])-p_id.unit_build_time_mod) + " days");
			_y += 100;
		}
	}
	if production_unit_display != -1{//check if unit to produce is selected
		var _u = global.unit_data[? string(production_unit_display)];
		//draw_set_color(global.menu_col1);
		//draw_rectangle(global.menu_box_x, 31, global.menu_box_x+global.menu_box_x_offset, 734, false);
		//draw_sprite_stretched(sMenuSecondLayer, 0, global.menu_box_x, 35, 400, 700);
		//draw_sprite_ext(sMenuSecondLayer, 0, global.menu_box_x, 35, 0.7874015748031496, 0.7, 0, _b_color, 1);
		draw_set_color(c_gray);
		//draw_rectangle(1097, 31, 1100, 735, false);
		draw_sprite(sUnitsBig, production_unit_display, 740, 100);
		draw_sprite_ext(s9Slice, 0, 740, 300, 2.5, 3.3, 0, c_white, 1);
	
		draw_set_color(c_white);
		
		// DRAW UNIT STATS IN LOOP
		var	_x = 760,
			_y = 355,
			_info;
		draw_text(_x, _y-40, _u[? "name"]);
		draw_set_font(font_18);
		for (var i = 0; i < 14; i++){
			_info = "";
			switch (i){
				case 2:
				_info = "MP: ";
				_name = "mp";
				break;
				case 3:
				_info = "SPD: ";
				_name = "spd";
				break;
				case 6:
				_info = "Supply need: ";
				_name = "supply";
				break;
				case 7:
				_info = "Atk: ";
				_name = "atk";
				break;
				case 8:
				_info = "Def: ";
				_name = "def";
				break;
				case 9:
				_info = "Hard atk: ";
				_name = "hard_atk";
				break;
				case 10:
				_info = "Toughness: ";
				_name = "tough";
				break;
				case 11:
				_info = "Terrain profile: ";
				_name = "ter_prof";
				break;
			}
			if _info != ""{
				draw_text(_x, _y, _info + string(_u[? _name]));
				_y += 30;
			}
		}//end of draw loop
		draw_set_font(font_basic);
		
		
		results = button_detect(_x, 630, sExitMenu, 0);
		button_draw(results, sExitMenu, 0, _x, 630);
		draw_text(_x+5, 632, "Produce");
		if results == 2 and _u[? "mp"] <= p_id.mp{//recuit unit
			p_id.mp -= _u[? "mp"];
			if ds_list_size(p_id.production_list) == 0 ds_list_add(p_id.production_list, string(production_unit_display) + "," + _id.tile_id + "," + _u[? "ic"] + "," + string(real(_u[? "d"])-p_id.unit_build_time_mod) + "," + string(real(_u[? "d"])-p_id.unit_build_time_mod));// add unit to que
			else ds_list_insert(p_id.production_list, ds_list_size(p_id.production_list), string(production_unit_display) + "," + _id.tile_id + "," + _u[? "ic"] + "," + string(real(_u[? "d"])-p_id.unit_build_time_mod) + "," + string(real(_u[? "d"])-p_id.unit_build_time_mod));// add unit to que
			production_unit_display = -1;
		}
	}
	#endregion
	break;
}// end of button pressed switch
if button_pressed != -1{
	draw_set_color(c_gray);
	draw_rectangle(697+global.menu_box_x_offset, 31, 700+global.menu_box_x_offset, 735, false);//menu right side line
}

	draw_set_color(c_black);
	draw_set_font(font_13);
	var _x = -119,
		_y = -20,
		_index;
	// create menu selection slider
	for (var i = 0; i < 6; i++){
		_x += 117;
		_index = 0;
		switch(i){
			case 0:
			_name = "Country";
			break;
			case 1:
			_name = "Economy";
			break;
			case 2:
			_name = "Units";
			break;
			case 3:
			_name = "Technology";
			break;
			case 4:
			_name = "Deployment";
			if unit_to_deploy == -2 _index = 2;
			break;
			case 5:
			_name = "production";
			break;
		}
		
		results = button_detect(_x, _y, sMenuSelection, _index);
		button_draw(results, sMenuSelection, _index, _x, _y);
		if button_pressed != i draw_sprite(sMenuSelection, _index, _x, _y);
		else draw_sprite(sMenuSelection, 1, _x, _y);
		if results == 2 button_pressed = i;
		if i == 5 _x += 10;
		draw_set_halign(fa_center);
		draw_text(_x+65, 10, _name);
		draw_set_halign(fa_left);
		
	}
	draw_set_font(font_basic);

if button_pressed != -1{
	// draw menu exit button
	draw_set_color(c_white);
	results = button_detect(500, 660, sExitMenu, 0);
	button_draw(results, sExitMenu, 0, 500, 660);
	draw_text(505, 662, "Close");
	if results == 2 button_pressed = -1;
}

draw_sprite_ext(s9Slice2, 0, 0, 735, 17, 1, 0, c_white, 1);// Draw bottom bar railing