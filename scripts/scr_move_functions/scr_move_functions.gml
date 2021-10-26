function get_path_to_province(tile_id, target_tile_id, war_list, name){ // tile id as string
	
	
	if tile_id == target_tile_id return undefined;
	
	var target_reached = false,
		frontier_queue = ds_priority_create();
		
	var target_x = global.data[? target_tile_id][? "x"],
		target_y = global.data[? target_tile_id][? "y"],
		start_x = global.data[? tile_id][? "x"],
		start_y = global.data[? tile_id][? "y"],
		path_to_target_list = ds_list_create(),
		reached_list = ds_list_create();
		
	ds_priority_add(frontier_queue, tile_id, 0);
	
	show_debug_message("ENTERING 1st WHILE");
	while (ds_priority_size(frontier_queue) > 0){// GET LIST OF PATH OR CANCEL SEARCH IF IMPOSSIBLE
		
		tile_id = ds_priority_find_min(frontier_queue);
		
		if tile_id == target_tile_id{
			ds_list_add(reached_list, target_tile_id);
			target_reached = true;
			break;
		}
		
		ds_list_add(reached_list, tile_id);
		
		ds_priority_delete_min(frontier_queue);
		
		var paths_list = global.data[? tile_id][? "path"],
			lis_len = ds_list_size(paths_list);
			
			
		for (var i = 0; i < lis_len; i++){// loop trough paths
			var tile = paths_list[| i],
				_id = global.province_id_list[? tile];
			
			if _id.owner == name or ds_list_find_index(war_list, _id.owner) != -1{//check if owner or at war to move in prov

				if ds_list_find_index(reached_list, tile) == -1 and ds_priority_find_priority(frontier_queue, tile) == undefined{//check if owner or at war to move in prov
					ds_priority_add(frontier_queue, tile, round(point_distance(_id.my_x, _id.my_y, target_x, target_y)+point_distance(_id.my_x, _id.my_y, start_x, start_y)));
				}
			}
		}// end of loop trough paths
	}// end of 1st while
	
	
	if target_reached{// PATH IS POSSIBLE
		
		ds_list_add(path_to_target_list, reached_list[| 0]);
		ds_list_delete(reached_list, 0);
		var passed_tiles = ds_list_create();
		
		show_debug_message("ENTERING 2nd WHILE");
		
		while (target_reached){// FILTER LIST AND CONSTRUCT PATH
			
			lis_len = ds_list_size(reached_list)
			var direct_paths = 0,
				path_tiles = array_create(0),
				last_distance = 0,
				next_tile = "";
				
			for (var i = 0; i < lis_len; i++){// loop trough paths
				tile = reached_list[| i];
				
				// if path in visited tiles
				if ds_list_find_index(global.data[? tile][? "path"], path_to_target_list[| ds_list_size(path_to_target_list)-1]) != -1 and ds_list_find_index(passed_tiles, tile) == -1{
					//show_debug_message(tile);
					path_tiles[direct_paths] = tile;
					direct_paths++;
				
				// no possible paths, taking a step back
				}else if i == lis_len-1 and direct_paths == 0{// continuation for path not found, take a step back
					show_debug_message("TAKING A STEP BACK");
					ds_list_delete(path_to_target_list, ds_list_size(path_to_target_list)-1);
					
					
					if is_undefined(path_to_target_list[| 0]){// FAIL CHECK
						return undefined;
					}
				}
			}
			
			for (var i = 0; i < direct_paths; i++){// loop trough paths directly linked to current prov
				
				_id = global.province_id_list[? path_tiles[i]];
				show_debug_message(path_tiles[i]);
				var distance = round(point_distance(_id.my_x, _id.my_y, target_x, target_y)+point_distance(_id.my_x, _id.my_y, start_x, start_y));
				if last_distance > distance or last_distance == 0{
					last_distance = distance;
					tile = path_tiles[i];
					next_tile = "found";
				}
				ds_list_add(passed_tiles, path_tiles[i]);
				// TEST / DELETE THE TILE TOUCHED
				//ds_list_delete(reached_list, ds_list_find_index(reached_list, tile));
			}
			
			if next_tile == "found"{
				//show_debug_message("ADDING TILE: " + tile);
				ds_list_add(path_to_target_list, tile);
				if tile == target_tile_id target_reached = false; 
				ds_list_delete(reached_list, ds_list_find_index(reached_list, tile));
			}else{
				ds_list_clear(passed_tiles);
			}
		}
		
		
		ds_list_delete(path_to_target_list, 0);
		show_debug_message("Exiting with ready path");

		return path_to_target_list;

	}else{
		show_debug_message("Exiting no path found");
		return undefined;
	}
}


function unit_move_delete(_id, unit){
	if ds_list_find_index(_id.moving_units_list, unit) != -1{// CHECK IF UNIT ALREADY ON THE MOVE
		var _pos = ds_list_find_index(_id.moving_units_list, unit);
		ds_list_delete(_id.moving_units_list, _pos);
		ds_list_delete(_id.distance_list, _pos);
		ds_list_delete(_id.move_to_list, _pos);
						
		_id.move_to--;
	}
}

function unit_move_add(_id, _target_id, unit){
		show_debug_message(_id);
		show_debug_message(_target_id);
		show_debug_message(unit);
		ds_list_add(_id.moving_units_list, unit);
		ds_list_add(_id.distance_list, point_distance(_id.my_x, _id.my_y, _target_id.my_x, _target_id.my_y));
		ds_list_add(_id.move_to_list, _target_id.tile_id);
						
		_id.move_to++;
		
		//if _id.owner == global.player and !audio_is_playing(aAaahh) and !audio_is_playing(aYes) audio_play_sound(aAaahh, 10, 0);
}

function ter_tech_move_mod(terrain, _id){
	switch (terrain){
		case 0:
		return _id.plains_move_mod;
		break;
		case 1:
		return _id.desert_move_mod;
		break;
		case 2:
		return _id.urban_move_mod;
		break;
		case 3:
		return _id.hills_move_mod;
		break;
		case 4:
		return _id.forest_move_mod;
		break;
		case 5:
		return _id.suburban_move_mod;
		break;
	}
}



function mouse_select_area(px, py, rx, ry){
	
	var tlbr = (x>px and x<rx and y>py and y<ry);
	var bltr = (x>px and x<rx and y<py and y>ry);
	var brtl = (x<px and x>rx and y<py and y>ry);
	var trbl = (x<px and x>rx and y>py and y<ry);
	
	if (tlbr || bltr || brtl || trbl){
		selected = true;
	}else{
		selected = false;
	}
}


/*
function get_path_to_province(tile_id, target_tile_id, war_list, name){ // tile id as string
	show_debug_message("ENTERING PATH FINDING!");
	show_debug_message("START: " + tile_id + " END :" + target_tile_id);
	show_debug_message("SUCCESS RATIO: " + string(global.debug_success/global.debug_fail) + "   F: " + string(global.debug_fail) + "   J: " + string(global.debug_jump) + "   S: " + string(global.debug_success));
	if tile_id == target_tile_id return undefined;
	
	var target_reached = false,
		frontier_queue = ds_priority_create();
		
	var target_x = global.data[? target_tile_id][? "x"],
		target_y = global.data[? target_tile_id][? "y"],
		path_to_target_list = ds_list_create(),
		reached_list = ds_list_create();
		
	ds_priority_add(frontier_queue, tile_id, 0);
	
	show_debug_message("ENTERING 1st WHILE");
	while (ds_priority_size(frontier_queue) > 0){// GET LIST OF PATH OR CANCEL SEARCH IF IMPOSSIBLE
		
		tile_id = ds_priority_find_min(frontier_queue);
		
		if tile_id == target_tile_id{
			ds_list_add(reached_list, target_tile_id);
			target_reached = true;
			break;
		}
		
		ds_list_add(reached_list, tile_id);
		
		ds_priority_delete_min(frontier_queue);
		
		//show_debug_message(tile_id);
		var paths_list = global.data[? tile_id][? "path"],
			lis_len = ds_list_size(paths_list);
			
			
		for (var i = 0; i < lis_len; i++){// loop trough paths
			var tile = paths_list[| i],
				_id = global.province_id_list[? tile];
			
			if _id.owner == name or ds_list_find_index(war_list, _id.owner) != -1{//check if owner or at war to move in prov

				if ds_list_find_index(reached_list, tile) == -1 and ds_priority_find_priority(frontier_queue, tile) == undefined{//check if owner or at war to move in prov
					ds_priority_add(frontier_queue, tile, round(point_distance(_id.my_x, _id.my_y, target_x, target_y)));
				}
			}
		}// end of loop trough paths
	}// end of 1st while
	
	
	if target_reached{// PATH IS POSSIBLE
		
		ds_list_add(path_to_target_list, reached_list[| 0]);
		ds_list_delete(reached_list, 0);
		var passed_tiles = ds_list_create();
		
		show_debug_message("ENTERING 2nd WHILE");
		
		while (target_reached){// FILTER LIST AND CONSTRUCT PATH
			
			lis_len = ds_list_size(reached_list)
			var direct_paths = 0,
				path_tiles = array_create(0),
				last_distance = 0,
				next_tile = "";
				
			for (var i = 0; i < lis_len; i++){// loop trough paths
				tile = reached_list[| i];
				
				// if path in visited tiles
				if ds_list_find_index(global.data[? tile][? "path"], path_to_target_list[| ds_list_size(path_to_target_list)-1]) != -1 and ds_list_find_index(passed_tiles, tile) == -1{
					//show_debug_message(tile);
					path_tiles[direct_paths] = tile;
					direct_paths++;
				
				// no possible paths, taking a step back
				}else if i == lis_len-1 and direct_paths == 0{// continuation for path not found, take a step back
					//show_debug_message("TAKING A STEP BACK");
					ds_list_delete(path_to_target_list, ds_list_size(path_to_target_list)-1);
					
					
					if is_undefined(path_to_target_list[| 0]){// FAIL CHECK
						show_debug_message("PATH CONSTRUCTION FAILED!");
						global.debug_fail++;
						return undefined;
					}
				}
			}
			
			for (var i = 0; i < direct_paths; i++){// loop trough paths directly linked to current prov
				
				_id = global.province_id_list[? path_tiles[i]];
				var distance = round(point_distance(_id.my_x, _id.my_y, target_x, target_y));
				if last_distance > distance or last_distance == 0{
					last_distance = distance;
					tile = path_tiles[i];
					next_tile = "found";
				}
				ds_list_add(passed_tiles, path_tiles[i]);
				// TEST / DELETE THE TILE TOUCHED
				//ds_list_delete(reached_list, ds_list_find_index(reached_list, tile));
			}
			
			if next_tile == "found"{
				//show_debug_message("ADDING TILE: " + tile);
				ds_list_add(path_to_target_list, tile);
				if tile == target_tile_id target_reached = false; 
				ds_list_delete(reached_list, ds_list_find_index(reached_list, tile));
			}else{
				ds_list_clear(passed_tiles);
			}
		}
		
		
		ds_list_delete(path_to_target_list, 0);
		show_debug_message("Exiting with ready path");
		global.debug_success++;
		return path_to_target_list;
	}else{
		show_debug_message("Exiting no path found");
		global.debug_fail++;
		return undefined;
	}
}
*/


function get_path_to_province_CHECK(tile_id, target_tile_id, my_name, name){ // tile id as string
	if tile_id == target_tile_id return false;
	
	var target_reached = false,
		frontier_queue = ds_priority_create();
		
	var target_x = global.data[? target_tile_id][? "x"],
		target_y = global.data[? target_tile_id][? "y"],
		start_x = global.data[? tile_id][? "x"],
		start_y = global.data[? tile_id][? "y"],
		path_to_target_list = ds_list_create(),
		reached_list = ds_list_create();
		
	ds_priority_add(frontier_queue, tile_id, 0);
	
	show_debug_message("ENTERING 1st WHILE");
	while (ds_priority_size(frontier_queue) > 0){// GET LIST OF PATH OR CANCEL SEARCH IF IMPOSSIBLE
		
		tile_id = ds_priority_find_min(frontier_queue);
		
		if tile_id == target_tile_id{
			ds_list_add(reached_list, target_tile_id);
			target_reached = true;
			break;
		}
		
		ds_list_add(reached_list, tile_id);
		
		ds_priority_delete_min(frontier_queue);
		
		var paths_list = global.data[? tile_id][? "path"],
			lis_len = ds_list_size(paths_list);
			
			
		for (var i = 0; i < lis_len; i++){// loop trough paths
			var tile = paths_list[| i],
				_id = global.province_id_list[? tile];
			
			if _id.owner == name or _id.owner == my_name{//check if owner or at war to move in prov

				if ds_list_find_index(reached_list, tile) == -1 and ds_priority_find_priority(frontier_queue, tile) == undefined{//check if owner or at war to move in prov
					ds_priority_add(frontier_queue, tile, round(point_distance(_id.my_x, _id.my_y, target_x, target_y)+point_distance(_id.my_x, _id.my_y, start_x, start_y)));
				}
			}
		}// end of loop trough paths
	}// end of 1st while
	
	
	if target_reached{// PATH IS POSSIBLE
		
		ds_list_add(path_to_target_list, reached_list[| 0]);
		ds_list_delete(reached_list, 0);
		var passed_tiles = ds_list_create();
		
		show_debug_message("ENTERING 2nd WHILE");
		
		while (target_reached){// FILTER LIST AND CONSTRUCT PATH
			
			lis_len = ds_list_size(reached_list)
			var direct_paths = 0,
				path_tiles = array_create(0),
				last_distance = 0,
				next_tile = "";
				
			for (var i = 0; i < lis_len; i++){// loop trough paths
				tile = reached_list[| i];
				
				// if path in visited tiles
				if ds_list_find_index(global.data[? tile][? "path"], path_to_target_list[| ds_list_size(path_to_target_list)-1]) != -1 and ds_list_find_index(passed_tiles, tile) == -1{
					//show_debug_message(tile);
					path_tiles[direct_paths] = tile;
					direct_paths++;
				
				// no possible paths, taking a step back
				}else if i == lis_len-1 and direct_paths == 0{// continuation for path not found, take a step back
					show_debug_message("TAKING A STEP BACK");
					ds_list_delete(path_to_target_list, ds_list_size(path_to_target_list)-1);
					
					
					if is_undefined(path_to_target_list[| 0]){// FAIL CHECK
						return false;
					}
				}
			}
			
			for (var i = 0; i < direct_paths; i++){// loop trough paths directly linked to current prov
				
				_id = global.province_id_list[? path_tiles[i]];
				show_debug_message(path_tiles[i]);
				var distance = round(point_distance(_id.my_x, _id.my_y, target_x, target_y)+point_distance(_id.my_x, _id.my_y, start_x, start_y));
				if last_distance > distance or last_distance == 0{
					last_distance = distance;
					tile = path_tiles[i];
					next_tile = "found";
				}
				ds_list_add(passed_tiles, path_tiles[i]);
				// TEST / DELETE THE TILE TOUCHED
				//ds_list_delete(reached_list, ds_list_find_index(reached_list, tile));
			}
			
			if next_tile == "found"{
				//show_debug_message("ADDING TILE: " + tile);
				ds_list_add(path_to_target_list, tile);
				if tile == target_tile_id target_reached = false; 
				ds_list_delete(reached_list, ds_list_find_index(reached_list, tile));
			}else{
				ds_list_clear(passed_tiles);
			}
		}
		
		
		ds_list_delete(path_to_target_list, 0);
		show_debug_message("Exiting with ready path");
		ds_list_destroy(path_to_target_list)
		return true;
	}else{
		show_debug_message("Exiting no path found");
		return false;
	}
}