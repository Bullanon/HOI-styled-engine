// GLOBAL TECHNOLOGIES
global.tech_list_0 = ds_list_create();// X&Y , NAME, RESEARCHED (0/1) , ID.NEEDED_ID (for effect and sprite) , Description , COST&TIME(time is calculated by hour)&SPOT
ds_list_add(global.tech_list_0, "50&200,Basic crafting,0,0,IC build time - 2d                   Unit build time - 4d,10&800&0", undefined,
								"50&250,Basic tools,0,1,IC build time - 2d                   Unit build time - 4d,10&800&2", 0,
								"200&300,Asembly line,0,2,IC build time - 2d                   Unit build time - 4d,10&800&4", 2,
								"200&350,Brushes,0,3,IC build time - 2d                   Unit build time - 4d,10&800&6", 4,
								"200&400,Kr8zy Glue,0,4,IC build time - 2d                   Unit build time - 4d,10&800&8", 6,
								"50&350,Basic fanning,0,5,desert_move_mod + 0.1%  desert_combat_mod + 0.1%,10&800&10", undefined,
								"50&400,Luxury furs,0,6,desert_move_mod + 0.1%  desert_combat_mod + 0.1%,10&800&12", 10,
								"50&450,LED collars,0,7,desert_move_mod + 0.1%  desert_combat_mod + 0.1%,10&800&14", 12,
								"50&500,O2Cool,0,8,desert_move_mod + 0.1%  desert_combat_mod + 0.1%,10&800&16", 14,
								"350&200,Custom forums,0,9,Tech research time -3%,10&800&18", undefined,
								"350&250,OC templates,0,10,Tech researc time and cost -2%,10&800&20", 18,
								"350&300,Hybrids,0,11,Tech research cost -5%,10&800&22", 20,
								"500&200,Buying in bulk,0,12,Unit supply consumption -0.05%,10&800&24", undefined,
								"500&250,Free shipping,0,13,Unit supply consumption -0.05%,10&800&26", 24,
								"500&300,Ride sharing,0,14,All movement mods +0.0.5%,10&800&28", 26,
								"500&350,W0lting,0,15,Unit supply consumption -0.08%,10&800&30", 28,
								"500&400,Pocky sticks,0,16,Does literally nothing,10&800&52", 30,
								"200&200,FTMS,0,17,FTM Supremacy,10&800&32", undefined,
								"200&250,MTFS,0,18,MTF Supremacy,10&800&34", undefined,
								"200&500,Subsidies,0,19,Does literally nothing,10&800&36", undefined,
								"200&550,Handouts,0,20,Does literally nothing,10&800&38", 38,
								"200&600,Mandatory HRT,0,21,Does literally nothing,10&800&40", 40,
								"350&400,TPBR act,0,22,Does literally nothing,10&800&42", undefined,
								"350&450,SSC,0,23,Does literally nothing,10&800&44", 44,
								"500&450,DA,0,24,Does literally nothing,10&800&46", 44,
								"350&500,365d June,0,25,Does literally nothing,10&800&48", 46,
								"500&500,e621,0,26,Does literally nothing.,10&800&50", 48,
								"350&550,It's canon,0,27,Confirm every ship by law.,10&800&52", 50,
								
								"50&200,Furpile,0,28,Fluffy and deadly UwU. Cheap fodder suitable for urban combat but no matter how valid these fluffballs won't last a second on a desert. (unit unlock),10&800&22", undefined,
								"50&250,Pegasisters,0,29,'It's called clopping dad'      These (((sisters))) work as a cavarly substitute of sorts. (unit unlock),10&800&24", 56,);
// REMEMBER TO UPDATE TECH CUTOFF!
/*
x + 150
y + 50
if you want tech to lock another tech do so when completing the tech in effects


*/

// MAX TECH TREE MAX SIZES ARE 9V and 5R with last row accomidating 3R (43/43) is max amount
function get_tech_list(unit_types, list){
	switch (unit_types){//get players tech type
		case 0:
		ds_list_copy(list, global.tech_list_0);
		break;
	}
}

function get_tech_cutoff(p_id){
	switch (p_id.unit_types){//get tech cutoff (social tech amount x 2)
		case 0:
		var _cutoff = 56;
		break;
	}
	return _cutoff;
}

function draw_titles(tech, index){// draw tech titles
	draw_set_color(c_white);
	draw_set_font(font_15);
	switch (tech){//get tech cutoff (social tech amount x 2)
		case 0:
		if index == 0{// ECON TECH TEXT
			draw_text(50, 170, "Manufacturing");
			draw_text(50, 310, "Climate control");
			draw_text(350, 170, "Research");
			draw_text(500, 170, "Logistics");
			draw_text(200, 450, "HRT");
			draw_text(350, 350, "Social");
		}else{// MILI TECH TEXT
			draw_text(50, 170, "Units");
		}
		break;
	}
}

function get_tech_effect(faction, tech){
	switch (faction){
		case 0:
		//show_message(string(tech) + " DEVELOPED");
		#region// FANDOMS UNDEVIDED
		switch (tech){
			case 0:
			ic_build_time_mod += 2;
			unit_build_time_mod += 4;
			break;
			case 1:
			ic_build_time_mod += 2;
			unit_build_time_mod += 4;
			break;
			case 2:
			ic_build_time_mod += 2;
			unit_build_time_mod += 4;
			break;
			case 3:
			ic_build_time_mod += 2;
			unit_build_time_mod += 4;
			break;
			case 4:
			ic_build_time_mod += 2;
			unit_build_time_mod += 4;
			break;
			case 5:
			desert_move_mod += 0.1;
			desert_combat_mod += 0.1;
			break;
			case 6:
			desert_move_mod += 0.1;
			desert_combat_mod += 0.1;
			break;
			case 7:
			desert_move_mod += 0.1;
			desert_combat_mod += 0.1;
			break;
			case 8:
			desert_move_mod += 0.1;
			desert_combat_mod += 0.1;
			break;
			case 9:
			tech_time_mod -= 0.03;
			break;
			case 10:
			tech_time_mod -= 0.02;
			tech_cost_mod -= 0.02;
			break;
			case 11:
			tech_cost_mod -= 0.05;
			break;
			case 12:
			supply_consumption_mod -= 0.05;
			break;
			case 13:
			supply_consumption_mod -= 0.05;
			break;
			case 14:
			plains_move_mod += 0.05;
			plains_combat_mod += 0.05;
			desert_move_mod += 0.05;
			desert_combat_mod += 0.05;
			urban_move_mod += 0.05;
			urban_combat_mod += 0.05;
			hills_move_mod += 0.05;
			hills_combat_mod += 0.05;
			forest_move_mod += 0.05;
			forest_combat_mod += 0.05;
			suburban_move_mod += 0.05;
			suburban_combat_mod += 0.05;
			break;
			case 15:
			supply_consumption_mod -= 0.08;
			break;
			case 16:
			
			break;
			case 17:
			
			break;
			
			
		}
		#endregion
		break;
	
	
	}
}