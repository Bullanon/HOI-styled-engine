/// @description Bang Data
if !audio_is_playing(sBangData){
	audio_play_sound(sBangData, 10, true);
}else{
	audio_stop_sound(sBangData);
}