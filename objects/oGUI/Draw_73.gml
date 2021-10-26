// Draw on top of map tiles

// GET GLOBAL SELECTED TILE TO DRAW ITS ARROW

// MAKE SYSTEM TO GET MOVING UNITS TO DRAW
if camera_get_view_width(oCamera.camera) < 800 and global.map_mode != 1{
	draw_set_color(c_black);
	draw_set_font(font_map);
	for (var i = 0; i < global.prov_amount; i++){
		var _id = global.province_id_list[? string(i)];
		// Draw province tile id's
		draw_text(_id.my_x-5, _id.my_y, _id.tile_id);
	}
}else if camera_get_view_width(oCamera.camera) > 1800 or global.map_mode == 1{
	draw_set_font(STATE_NAME);
	draw_set_color(c_black);
draw_text(1990, 1190, "Texas");
draw_text(1600, 930, "New Mexico");
draw_text(1010, 856, "California");
draw_text(2130, 910, "Arkansas");
draw_text(1355, 930, "Arizona");
draw_text(1143, 640, "Nevada");
draw_text(950, 380, "Oregon");
draw_text(1000, 145, "Washington");
draw_text(1300, 320, "Idaho");
draw_text(1395, 115, "Montana");
draw_text(1557, 438, "Wyoming");
draw_text(1380, 685, "Utah");
draw_text(1620, 685, "Colorado");
draw_text(1940, 295, "Dakota");
draw_text(1995, 685, "Kansas");
draw_text(2612, 438, "Michigan");
draw_text(2300, 700, "Missouri");
draw_text(2300, 410, "Illinois");
draw_text(2260, 1130, "Louisiana");
}
/// WHEN TILE SELECTED CHANGE COLOR OF ALL PATHS
/*
1. ENEMY
2. FRIENDLY
3. NEUTRAL