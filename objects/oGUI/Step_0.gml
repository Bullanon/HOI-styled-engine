if global.paused = false{
	timer--;
}
if timer == 0{
	if global.hour != 23{
		global.hour++;
	ds_list_clear(global.battles_list);
	}else{
		global.hour = 0;
		global.day++;
		#region // GLOBAL EVENT CHECKER
		if is_undefined(global.events[| 0]){
			ds_list_delete(global.events, 0);
			if ds_list_size(global.events) == 0 ds_list_add(global.events, "-,-");
		}
		var _date = pos_split(global.events[| 0], 0);
		show_debug_message(_date)
		if _date == string(global.day) + "." + global.months[| global.month_index] + "." + string(global.year){
			/*
			1 DATE
			2 COUNTRY
			3 SPRITE
			4 TEXT
	
			5 OPTIONS 1
			6 EFFECT id (SWITCH STATEMENT IN oCountry)
	
			7 (Potential) OPTION 2
			8 EFFECT id (SWITCH STATEMENT IN oCountry)
	
			*/
			show_debug_message("EVENT TRIGGERED");
			
			var _str = global.events[| 0],
				_country = pos_split(_str, 1),
				_id = country_get_id(_country);
			
			if is_string(_id){
				ds_list_delete(global.events, 0);
			}else{
				
				if _id.ai{
				var	_op1 = pos_split(_str, 4),
					_effect1 = pos_split(_str, 5),
					_op2 = undefined,
					_effect2 = undefined,
					_flip = 1;
				
				if pos_split(_str, 6) != 0{
					_op2 = pos_split(_str, 6);
					_effect2 = pos_split(_str, 7);
				}
			
				// AI CHOOSES RANDOMLY BETWEEN EVENTS
				if _effect2 != undefined _flip = choose(1, 2);
			
				switch (_flip){
					case 1:
					ds_list_insert(oInGameMenu.log_list, 0, _country + " went with " + _op1);
					_id.event_ = _effect1;
					break;
					case 2:
					ds_list_insert(oInGameMenu.log_list, 0, _country + " went with " + _op2);
					_id.event_ = _effect2;
					break;
				}
				ds_list_delete(global.events, 0);
			
				}else{//player
					_id.event_ = -2;
				}
			}//end of if string
		}
		#endregion
		if global.day-1 == global.month_days[| global.month_index]{
			global.day = 0;
			global.month_index++;
			if global.month_index == 12{
				global.month_index = 0;
				global.year++;
			}
		}
	}
	timer = global.game_spd[| global.spd]
	

	
}





