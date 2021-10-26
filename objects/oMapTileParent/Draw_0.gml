
depth = 1;
// Get fog of war and selected alpha
image_alpha = 1;
in_view = true;
var _id = global.faction_id_map[? owner];
if _id.ai = true{
	if !global.debug in_view = false;
	image_alpha = 0.7;
	var _path_lis = global.data[? tile_id][? "path"];
	var _paths = ds_list_size(_path_lis);
	for (var i = 0; i < _paths; i++){
		if global.province_id_list[? string(_path_lis[| i])].owner == global.player{
			image_alpha = 1;
			in_view = true;
			break;
		}
	}
}
if selected{
	image_alpha -= 0.4;
}

var offset = 1;
if camera_get_view_width(oCamera.camera) < 1800{
for (x = -offset; x <= offset; x += offset) {  
     for (y = -offset; y <= offset; y += offset) {  
          draw_sprite_ext(sprite_index,		//sprite
				image_index,				//sub img
				x+800,						//x pos
				y+2,						//y pos
				image_xscale, image_yscale,	//scale
				image_angle,				//angle
				c_black,					//col
				image_alpha);				//alpha
     }
}
}
x = 800;
draw_self();
depth = -10;

image_blend = ds_map_find_value(global.colors, owner);





