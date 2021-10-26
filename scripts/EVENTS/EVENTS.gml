// GLOBAL EVENTS
global.event_sprite = sEvent1;
global.events = ds_list_create();
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
/*
ds_list_add(global.events, "3.January.2030,CHAZ,1,Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries but also the leap into electronic typesetting remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.,Okay,0");
ds_list_add(global.events, "5.January.2030,x,2,Test text as content 2,Okay,1,Okay2,2");
ds_list_add(global.events, "7.January.2030,CHAZ,2,Test text as content 2,Okay,1,Okay2,2");
*/

ds_list_add(global.events, "-,-");