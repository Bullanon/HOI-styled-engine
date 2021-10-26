/// ADD VARIABLES FOR TECHNOLOGY MODIFIERS AND PLASE them on proper places to affect industry and battles

	
//NOT YET SAVED !!!
ai_last_power = 0;
at_war_with = ds_list_create();
deserting_units_list = ds_list_create();

scortched_earth = false;

research_funding = 100;
research_cost = 0;

money_last_turn = 0;
money_count = 0;
supply_stockpile = 0;
max_ic = 0;
units_to_deploy_map = ds_map_create();
production_list = ds_list_create();
tech_development_list = ds_list_create();

taken_cas = 0;
inflicted_cas = 0;


unit_types = 0;//	 GET FROM JSON!!!!!! (global.faction_data[? spawn_id][? "unit_type"];)
// these also may not be counted for in production of units


units_unlocked = ds_list_create();
ds_list_add(units_unlocked, true);
for (var i = 0; i < 8; i++){// out of all units only first starts out unlocked
	ds_list_add(units_unlocked, true);// change start unlocs here
}

event_ = 0;
my_h = global.hour;


// TECH MODS:

// COMBAT
unit_org_reqroup_mod = 1;// Base org given to unit that retreated from prov to prov
strategic_org_deploy_default = 20;// max org on deploy
org_recovery_rate = 4;// + org per day


// * the units own mod
plains_move_mod = 1;
plains_combat_mod = 1;
desert_move_mod = 1;
desert_combat_mod = 1;
urban_move_mod = 1;
urban_combat_mod = 1;
hills_move_mod = 1;
hills_combat_mod = 1;
forest_move_mod = 1;
forest_combat_mod = 1;
suburban_move_mod = 1;
suburban_combat_mod = 1;


// ECONOMY
ic_build_time_mod = 0;// - ic build days
unit_build_time_mod = 0;// - unit build days
administration_cost_mod = 2// administration cost added per prov amount (bigger is better)
tech_cost_mod = 2;// * reseach cost
tech_time_mod = 1.3;// * research time
wp_mod = 1000;// wealth produced by prov mod (the smaller the better)
pop_growth_mod = 0.02// Bigger means more pop growth
supply_consumption_mod = 1;// IC to supply conversion rate



total_pop_last_turn = 0;


my_month = -1;// start with -1 so diplomacy map will be created
relations_priority = ds_priority_create();

peace_offered_timer = 0;


//NOT YET SAVED !!!


money = 10;

total_ic = 0;
mob_lvl = 2;
tax_lvl = 20;// %
my_day = global.day;

total_pop = 0;
mp = 50000;

administration_cost = 0;


// economy slider values
ic_funding = 100;

ic_in_production = 0;
ic_production_need = 0;

ic_in_supply = 0;
ic_supply_need = 0;

ic_in_reinforce = 0;
ic_reinforce_need = 0;
	
	
unit_data_list = undefined;
spawn_id = string(global.spawn_country_as);
global.spawn_country_as++;
_name = global.faction_data[? spawn_id][? "name"];
ai = true;


ds_map_add(global.faction_id_map, _name, id);

// Make exeption for loaded game?
// Get a list of held provinces
/*
prov_list = ds_list_create();
for (var i = 0; i < 117; i++;){
	var _prov = global.data[? string(i)][? "owner"]
	if _prov == _name{
		ds_list_add(prov_list, _prov);
	}
}
*/

// 0 = PLAYER, 1 = PEACE, 2 = WAR, 3 = ALLY
/*
relations = ds_list_create();
var _map_len = ds_map_size(global.faction_data);
for (var i = 0; i < _map_len; i++;){
	var _name_ = global.faction_data[? string(i)][? _name];
	if _name_ == _name{
		ds_list_add(relations, global.faction_data[? string(i)][? "rel"]);
	}
}
*/
/// DELETE RELATIONS FROM FACTION JSON!

/// UNITS
units = ds_map_create();



// NOT SAVED!:
flag = global.faction_data[? spawn_id][? "flag"];
capital = global.faction_data[? spawn_id][? "cap"];

if _name == global.player{// get tech spite to use
	ai = false;
	
	
	switch(unit_types){
		case 0:
		global.tech_sprite = sTech1;
		break;
	
	}
}

//GET TECH MAP (THIS IS GOING TO BE A BITCH TO SAVE)

tech_list = ds_list_create();
get_tech_list(unit_types, tech_list);




if ai{// Creates a list of lists with every tech path being it's own list. the items in lists are the tech indexes
ai_tech_list = ds_list_create();

var _lis_size = ds_list_size(tech_list),
	_counter = -1;
for (var i = 1; i < _lis_size; i += 2){// loop trough techs to create ai tecch priority list
	show_debug_message(pos_split(tech_list[| i-1], 1));
	if tech_list[| i] == undefined{// first tech in a row
		var _tech_sub_list = ds_list_create();
		ds_list_add(_tech_sub_list, i-1);
		ds_list_add(ai_tech_list, _tech_sub_list);
	}
}

for (var i = 1; i < _lis_size; i += 2){// loop trough techs again to fill out paths
	show_debug_message(pos_split(tech_list[| i-1], 1));
	if tech_list[| i] != undefined{// tech not first in row
		var _sub_lis = ai_tech_list[| _counter];
		show_debug_message(ds_list_size(_sub_lis))
		ds_list_add(_sub_lis, i-1);
		i += 2;
		while !is_undefined(tech_list[| i]){// as long as there are items in tech path add them to the list
			show_debug_message(pos_split(tech_list[| i-1], 1));
			ds_list_add(_sub_lis, i-1);
			i += 2;
		}
	}
	_counter++;
}


/*
_counter = 0;
repeat(ds_list_size(ai_tech_list)){
	show_debug_message(typeof(ai_tech_list[| _counter]));
	var _lis = ai_tech_list[| _counter],
		_lis_size = ds_list_size(_lis);
	for (var i = 0; i < _lis_size; i++){
		show_debug_message(pos_split(tech_list[| _lis[| i]], 1));
	}
	_counter++;
}

_counter = 0;
repeat(ds_list_size(ai_tech_list)){
	show_message(ds_list_size(ai_tech_list[| _counter]));
	_counter++;
}
*/

}// end of if ai