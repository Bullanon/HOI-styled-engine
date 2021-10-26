button_pressed = -1;
global.menu_box_x = 700;
global.menu_box_x_offset = 400;
log_list = ds_list_create();
ds_list_add(log_list, "start");

last_selected_unit = -1;

last_map_mode = -1;
unit_to_deploy = -1;

production_slider = 0;
que_slider = 0;
production_unit_display = -1;

deploy_slider = 0;

tech_tree = 0;// 0 or 1
tech_display = -1;

country_to_view = global.player;
