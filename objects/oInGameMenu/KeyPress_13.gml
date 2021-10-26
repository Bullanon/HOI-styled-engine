/// @description Insert log data
ds_list_insert(log_list, 0, keyboard_string);

if is_real_number(keyboard_string) == 1 and real(keyboard_string) >= 0 and real(keyboard_string) <= 116{
	// show location
	var _id = global.province_id_list[? keyboard_string];
	oCamera.x = _id.my_x;
	oCamera.y = _id.my_y;
}

if string_length(keyboard_string) == 0{
	with (oMapTileParent){
		if selected oInGameMenu.war_declare_cheat = owner;
	}
}else if keyboard_string == "+"{
	with (oMapTileParent){
		if selected{
			var _id = global.faction_id_map[? owner],
				_id2 = global.faction_id_map[? oInGameMenu.war_declare_cheat];
			ds_list_add(_id.at_war_with, oInGameMenu.war_declare_cheat);
			ds_list_add(_id2.at_war_with, owner);
		}
	}
}

if keyboard_string = "meme" shader_set(shd_bit);
if keyboard_string = "stop" shader_reset();
keyboard_string = "";

