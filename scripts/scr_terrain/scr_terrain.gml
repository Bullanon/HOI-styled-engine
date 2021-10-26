// UNIQUE PROVINCES:
function get_prov_image_index(index, tile_id){
	var name = global.data[? tile_id][? "name"],
		state = global.data[? tile_id][? "state"];
	switch (name){
		case "Seattle":
		index = 7;
		break;
		case "Detroit":
		index = 8;
		break;
		case "Los Angeles":
		index = 9;
		break;
		case "Chicago":
		index = 10;
		break
		case "Denver":
		index = 11;
		break
		case "Salt Lake City":
		index = 12;
		break
		case "Helena":
		index = 13;
		break
		case "Silicon Valley":
		index = 14;
		break;
	
	}
	
	if index == 4 and state == "California" index = 6;
	
	return index;
}







function get_terrain(_id){
	switch (_id){
		case 0: // Terrain
		_terrain = "Urban";
		break;
		
	}
	return _terrain
}
