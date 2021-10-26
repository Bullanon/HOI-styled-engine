var camX = camera_get_view_x(camera),
	camY = camera_get_view_y(camera),
	camW = camera_get_view_width(camera),
	camH = camera_get_view_height(camera);

if mouse_check_button(mb_middle){
	
	var move_x = device_mouse_x_to_gui(0) - mouse_x_previous,
		move_y = device_mouse_y_to_gui(0) - mouse_y_previous,
		zoom_mod = camW/900;
	
	camX -= move_x*zoom_mod;
	camY -= move_y*zoom_mod;
	x -= move_x*zoom_mod;
	y -= move_y*zoom_mod;
	
}else{
	if keyboard_check(ord("W")) y -= MOVE_SPD;
	if keyboard_check(ord("S")) y += MOVE_SPD;
	if keyboard_check(ord("A")) x -= MOVE_SPD;
	if keyboard_check(ord("D")) x += MOVE_SPD;
}


var targetX = x - camW/2,
	targetY = y - camH/2;

targetX = clamp(targetX, 0, room_width - camW);
targetY = clamp(targetY, 0, room_height - camH);

camX = lerp(camX, targetX, CAM_SMOOTH);
camY = lerp(camY, targetY, CAM_SMOOTH);

// ZOOMING
var wheel = mouse_wheel_down() - mouse_wheel_up();
if wheel != 0 and camW <= MIN_ZOOM and camW >= MAX_ZOOM{
	wheel *= 0.1;
	var addW = camW * wheel,
		addH = camH * wheel;
	
	if camW+addW > MIN_ZOOM{
		camW = MIN_ZOOM;
		camH = MIN_ZOOM*RES_RATIO;
	}else if camW+addW < MAX_ZOOM{
		camW = MAX_ZOOM;
		camH = MAX_ZOOM*RES_RATIO;
	}else{
		camW += addW;
		camH += addH;
		camX -= addW/2;
		camY -= addH/2;
	}
}

camera_set_view_pos(camera, camX, camY);
camera_set_view_size(camera, camW, camH);
mouse_x_previous = device_mouse_x_to_gui(0);
mouse_y_previous = device_mouse_y_to_gui(0);