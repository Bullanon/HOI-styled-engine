function get_path_to_province_test(tile_id, target_tile_id, war_list, name){ // tile id as string
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
		return path_to_target_list;
	}else{
		show_debug_message("Exiting no path found");
		return undefined;
	}
}