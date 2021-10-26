/// @description Debuggin

draw_set_color(c_white);
var _lis_size = ds_list_size(deserting_units_list),
	_y = 70;
for (var i = 0; i < _lis_size; i++){
	draw_text(900, _y, deserting_units_list[| i]);
	_y += 30;
}

