// Global AI value ratings here
global.debug = false;

// ECONOMY
global.bal_ic_vs_unit = 5;
global.bal_build_ic = 50;// minimum money surplus per day before ai builds IC

global.bal_tech_research_cap = 1;// MAX TECH TO TESEARCH AT A TIME

// DIPLOMACY
global.bal_ai_at_war_with_weight = 3;// How much value is placed on ongoing wars
global.bal_dib_army_strenght_weight = 1;// The weight of army strenght
global.bal_border_prov_dib_weight = 1;// The weight or bordering provinces
global.bal_ai_war_declare_stresshold = 1;
global.bal_war_chance = 1;// Default value of how likely the ai is to declare war
global.bal_offer_peace_offset = 1;// Smaller number makes ai more likely to ask for peace

// COMBAT
global.bal_attack_to_prov_stresshold = 20;// Higher value makes unit attacking enemy prov less likely
global.bal_units_in_prov = 5;// Value of own unit's located in prov
global.bal_enemy_units_in_prov = 8;// Value of enemy units in nearby provs
global.bal_enemy_prov_next_to_own_value = 5;// The value of each connected enemy province to ai's
global.bal_org_to_attack_stresshold = 10;// Minimum org required for ai unit to initiate an attack
global.bal_unit_distance_to_prov_weight = 100;// larger number means distance affects the decision less
global.bal_unit_moving_to_prov_weight = 5;// How much provs priority decreases when a unit is send there