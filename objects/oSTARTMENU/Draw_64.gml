// DRAW DEFAULT NEW GAME OPTIONS

var _list_size = ds_map_size(global.faction_data),
	_key = ds_map_find_first(global.faction_data),
	_x = 100,
	_y = 100;
	
	
var _flavor_text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

var _amount_to_show = 7;
countries_to_show = slider_create_vertical(30, 80, sSliderMenu, sSliderButtonVertical, countries_to_show, _list_size-_amount_to_show);



draw_set_color(c_white);
draw_set_font(font_24);
for (var i = 0; i < _list_size; i++){
	if i >= countries_to_show and _amount_to_show > 0{
	_amount_to_show--;
	draw_text(_x, _y-45, global.faction_data[? _key][? "name"]);
	
		var results = button_detect(_x, _y, sFlagsP1, 0);
		button_draw(results, sFlagsP1, global.faction_data[? _key][? "flag"], _x, _y);
		if results == 2{
			country_to_view = global.faction_data[? _key][? "name"];
		}
	_y += 180;
	}
	_key = ds_map_find_next(global.faction_data, _key);	
}

if country_to_view != ""{
	
	draw_text(600, 100, country_to_view);
	draw_text_ext(600, 160, _flavor_text, 40, 550);
	
	results = button_detect(600, 1000, sExitMenu, 0);
	button_draw(results, sExitMenu, 0, 600, 1000);
	draw_text(605, 1003, "Start");
	if results == 2{
		global.player = country_to_view;
		room_goto_next();
	}
}

draw_text_ext(1200, 500, "O: debug mode, ASWD: cam move, MOUSE WHEEL: zoom, MB_middle: cam panning, B: bang data, L: will just crash the game lel", 30, 300);


// AI CAN ATTACK PLAYER?
draw_text(1200, 340, "Can attack player:");
get_string_color(global.can_attack_player, 0.5);
if global.can_attack_player var _str = "YES";
else var _str = "NO";
draw_text(1200+string_width("Can attack player: "), 340, _str);
results = button_detect(1200, 400, sExitMenu, 0);
button_draw(results, sExitMenu, 0, 1200, 400);

if results == 2{
	if global.can_attack_player global.can_attack_player = false;
	else global.can_attack_player = true;
}
draw_set_color(c_white);


// DRAW AI AGRESSION SLIDER
global.bal_ai_war_declare_stresshold = slider_create(1200, 120, sSliderBase, sSliderButton, global.bal_ai_war_declare_stresshold, 100, "AI AGRESSION (lower the number means higher agression)");
get_string_color(global.bal_ai_war_declare_stresshold, 25);
draw_text(1200+sprite_get_width(sSliderBase)+40,105, string(global.bal_ai_war_declare_stresshold));