/// @description CLEAR DATA WHEN ANNEXED

ds_map_delete(global.faction_id_map, _name);


var _id = id;
if ds_list_size(units) > 0{// REMOVE UNITS THAT ARE RETREATING
	with (oMapTileParent){// loop trough provinces
		var _lis_size = ds_list_size(fleeing_units_list);
		for (var i = 0; i < _lis_size; i++){// loop trough fleeing units in provinces
			show_debug_message(fleeing_units_list[| i]);
			if !is_undefined(fleeing_units_list[| i]) var u_name = pos_split(fleeing_units_list[| i], 0);
			
			if !is_undefined(ds_map_find_value(_id.units, u_name)){// units is owned by country the country, deleting
				ds_list_delete(fleeing_units_list, i);
			}
		}
		remove_undefined(fleeing_units_list);
	}
}

with (oCountry){// Remove country from other countries war lists
	if ds_list_find_index(at_war_with, _id._name) != -1 ds_list_delete(at_war_with, ds_list_find_index(at_war_with, _id._name));
}






nuke_units(units);


ds_map_destroy(units_to_deploy_map);
ds_list_destroy(production_list);
ds_list_destroy(units_unlocked);