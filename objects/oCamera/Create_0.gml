
// 960, 480


#macro RES_W 1920
#macro RES_H 1080
#macro RES_RATIO RES_H/RES_W
#macro MIN_ZOOM 5000
#macro MAX_ZOOM 200
#macro RES_SCALE 1
#macro MOVE_SPD 5
#macro CAM_SMOOTH 0.5

view_enabled = true;
view_visible[0] = true;

camera = camera_create_view(0, 0, RES_W, RES_H);

view_set_camera(0, camera);

window_set_size(RES_W*RES_SCALE, RES_H*RES_SCALE);
surface_resize(application_surface, RES_W*RES_SCALE, RES_H*RES_SCALE);

display_set_gui_size(RES_W, RES_H);

var display_width = display_get_width();
var display_height = display_get_height();
var window_width = RES_W*RES_SCALE;
var window_height = RES_H*RES_SCALE;
window_set_position(display_width/2 - window_width/2, display_height/2 - window_height/2);

mouse_x_previous = device_mouse_x_to_gui(0);
mouse_y_previous = device_mouse_y_to_gui(0);