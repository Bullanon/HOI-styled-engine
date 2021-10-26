
//draw_text(200, 150, string(mouse_x-800) + "     " + string(mouse_y));

var p_id = global.faction_id_map[? global.player],
	_y = 1;
draw_set_font(font_18);
draw_set_color(c_green);
draw_set_halign(fa_right);
//draw_text(1700, _y, "FPS = " + string(fps));
draw_text(1800, _y, string(global.hour) + " " + string(global.day) + " " + global.months[| global.month_index] + " " + string(global.year));
draw_set_color(c_white);

show_debug_message(global.player);

draw_set_halign(fa_left);
draw_text(800, _y, "Industrial capacity: " + string(p_id.total_ic) + "    MP: " + round_number_to_string(p_id.mp) + "    Supplies: " + round_number_to_string(p_id.supply_stockpile) + "    Money: " + round_number_to_string(p_id.money));



/*

if px != -1{// draw mouse select rectangle
	draw_rectangle(px, py, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), true);
}
*/

// PLAYER EVENT MENU

/*
			1 DATE
			2 COUNTRY
			3 SPRITE
			4 SPRITE_FILE_NAME
			5 TEXT
	
			6 OPTIONS 1
			7 EFFECT id (SWITCH STATEMENT IN oCountry)
	
			8 (Potential) OPTION 2
			9 EFFECT id (SWITCH STATEMENT IN oCountry)
	
			*/
if p_id.event_ == -2{// player event menu
	global.paused = true;
	var _str = global.events[| 0],
		_index = real(pos_split(_str, 2)),
		_text = pos_split(_str, 3),
		_op1 = pos_split(_str, 4),
		_effect1 = pos_split(_str, 5),
		_op2 = pos_split(_str, 6),
		_effect2 = undefined;
		
		if _op2 != undefined _effect2 = pos_split(_str, 8);
		
		draw_set_color(c_white);
		draw_sprite_ext(s9Slice, 0, 750, 100, 5, 5, 0, c_white, 1);
		
		
		
		

		var _x = 800,
			_y = 550,
			_button = sExitMenu;
			
		draw_sprite(global.event_sprite, _index, _x, 120);
		draw_text_ext(_x, 480, _text, 30, 950);
		
		// RESULTS 0-4 RESERVED FOR PEACE OPTIONS with 0 = NONE
		
		//option1
		results = button_detect(_x, _y, _button, 0);
		button_draw(results, _button, 0, _x, _y);
		draw_text(_x+7, _y+5, _op1);
		
		if results == 2{
			if _effect1 > 4 p_id.event_ = _effect1;
			else{
				switch (_effect1){
					case 1:// WHITE PEACE
					make_peace(p_id, global.faction_id_map[? dot_split(_str, 1)]);
					p_id.event_ = -1;
					break;
				}
			}
			global.paused = false;
			ds_list_delete(global.events, 0);
			ds_list_insert(oInGameMenu.log_list, 0, pos_split(_str, 1) + " went with " + _op1);
		}
		
		if _op2 != 0{//option2
			_y += 50;
			results = button_detect(_x, _y, _button, 0);
			button_draw(results, _button, 0, _x, _y);
			draw_text(_x+7, _y+5, _op2);
			if results == 2{
			if _effect2 > 4 p_id.event_ = _effect2;
			else p_id.event_ = -1;
			global.paused = false;
			ds_list_delete(global.events, 0);
			ds_list_insert(oInGameMenu.log_list, 0, pos_split(_str, 1) + " went with " + _op2);
		}
		
		
		}
		
		
		
}// end of if event