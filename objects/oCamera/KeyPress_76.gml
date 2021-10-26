/// @description load



if file_exists("savedata.save"){
	oInGameMenu.last_selected_unit = -1;
	//^^ reset all of these
	
	ds_list_clear(global.battles_list);
	
	// erase current game state
	global.loading = true;
	ds_map_clear(global.province_id_list); // Get new id's
	ds_map_clear(global.faction_id_map);
	with (oMapTileParent) instance_destroy();
	with (oCountry) instance_destroy();
	with (oGUI) instance_destroy();
	global.prov_menu = "";
	global.selected_tile_id = "";
	
	
	var _buffer = buffer_load("savedata.save");
	var _string = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	
	var _load_data = json_parse(_string);
	
	while (array_length(_load_data) > 0){
		var _load_entity = array_pop(_load_data);

		with (instance_create_layer(0, 0, layer, asset_get_index(_load_entity.obj))){
			
			show_debug_message(object_get_name(object_index));
			
			if object_get_name(object_index) == "oMapTileParent"{
			y = _load_entity.y;
			x = _load_entity.x;
			tile_id = _load_entity.tile_id;
			my_x = _load_entity.my_x;
			my_y = _load_entity.my_y;
			owner = _load_entity.owner;
			_name = _load_entity._name;
			my_h = _load_entity.my_h;
			my_d = _load_entity.my_d;
			var _units_list = _load_entity.units_list;
			move_to = _load_entity.move_to;
			var _move_to_list = _load_entity.move_to_list;
			var _distance_list = _load_entity.distance_list;
			var _moving_units_list = _load_entity.moving_units_list;
			color_t = _load_entity.color_t;
			max_ic = _load_entity.max_ic;
			ic = _load_entity.ic;
			ter = _load_entity.ter;
			pop = _load_entity.pop;
			image_index = _load_entity.image_index;
			image_blend = _load_entity.image_blend;
			sprite_index = _load_entity.sprite_index;
			ds_map_add(global.province_id_list, string(tile_id), id);
			
			var i = 0;
			var _lis_size = array_length(_units_list);
			units_list = ds_list_create();
			repeat (_lis_size){
				ds_list_add(units_list, _units_list[i]);
				i++;
			}
			i = 0;
			var i = 0;
			var _lis_size = array_length(_move_to_list);
			move_to_list = ds_list_create();
			repeat (_lis_size){
				ds_list_add(move_to_list, _move_to_list[i]);
				i++;
			}
			i = 0;
			var i = 0;
			distance_list = ds_list_create();
			repeat (_lis_size){
				ds_list_add(distance_list, _distance_list[i]);
				i++;
			}
			i = 0;
			var i = 0;

			moving_units_list = ds_list_create();
			repeat (_lis_size){
				ds_list_add(moving_units_list, _moving_units_list[i]);
				i++;
			}
			
			}else if object_get_name(object_index) == "oCountry"{
				show_debug_message("Loading country")
				spawn_id = _load_entity.spawn_id;
				_name = _load_entity._name;
				ai = _load_entity.ai;
				relations = _load_entity.relations;
				unit_name_list = _load_entity.unit_name_list; // MAke these 2 into vars
				unit_data_list = _load_entity.unit_data_list;
				flag = _load_entity.flag;
				money = _load_entity.money;
				total_ic = _load_entity.total_ic;
				mob_lvl = _load_entity.mob_lvl;
				tax_lvl = _load_entity.tax_lvl;
				my_day = _load_entity.my_day;
				total_pop = _load_entity.total_pop;
				mp = _load_entity.mp;
				administration_cost = _load_entity.administration_cost;
				ic_funding = _load_entity.ic_funding;
				ic_in_production = _load_entity.ic_in_production;
				ic_production_need = _load_entity.ic_production_need;
				ic_in_supply = _load_entity.ic_in_supply;
				ic_supply_need = _load_entity.ic_supply_need;
				ic_in_reinforce = _load_entity.ic_in_reinforce;
				ic_reinforce_need = _load_entity.ic_reinforce_need;
				
					var count = 0;
					units = ds_map_create();
					var _lis_len = array_length(unit_name_list);
					for (var i = 0; i < _lis_len; i++){
						data = ds_list_create();
						repeat (6){
							if unit_data_list[count] != "x"{
								ds_list_add(data, unit_data_list[count]);
							}else{
								ds_list_add(data, undefined);
							}
							count++;
						}
						ds_map_add(units, unit_name_list[i], data);
					}

				prov_list = _load_entity.prov_list;
				ds_map_add(global.faction_id_map, _name, id);
			}else if object_get_name(object_index) == "oGUI"{
				hour = _load_entity.hour;
				day = _load_entity.day;
				month_index = _load_entity.month_index;
				year = _load_entity.year;
				
			}
		}
	}
}
