/*
	General Configurations for GMSAI
	By Ghostrider [GRG]
	Copyright 2020
*/
#define GMSAI_difficultyBlue 0
#define GMSAI_difficultyRed 1
#define GMSAI_difficultyGreen 2
#define GMSAI_difficultyOrange 3

GMSAI_maxHeals = 1;  // Maximum # of times the AI can heal. Set to 0 to disable self heals.
GMSAI_minDamageForSelfHeal = 0.4;  // The damage a unit must sustain to self-heal. 
GMSAI_unitSmokeShell = "SmokeShellRed"; // The type of smoke units throw if damaged. Set to "" to disable.
GMSAI_baseSkill = 0.7;  // Base skill level for AI.
GMSAI_baseSkilByDifficulty = [
	0.5,  // blue 
	0.65, // Red 
	0.75, // green 
	0.9 // Orange 
];
GMSAI_money = [8, 12, 16, 20];
GMSAI_defaultAlertDistance = 350;
GMSA_alertDistanceByDifficulty = [200, 300,450,600];
GMSAI_defaultInteligence = 0.5;
GMSAI_intelligencebyDifficulty = [0.1,0.3,0.5,0.8];
GMSAI_maxReloadsInfantry = -1;  // Set to 0 to prevent reloads, 1..N to have a finite # of them
GMSAI_skillBlue = [ 
	// _skills params["_accuracy","_aimingSpeed","_shake","_spotDistance","_spotTime","_courage","_reloadSpeed","_commanding","_general"];
	[0.05,0.08],  // accuracy
	[0.1,0.12],  // aiming speed
	[0.1,0.15],  // aiming shake
	[0.50,0.60], // spot distance
	[0.50,0.60], // spot time
	[0.50,0.60], // couraget
	[0.50,0.60], // reload speed
	[0.75,0.80], // commandingMenu
	[0.70,0.80] // general, affects decision making
];
GMSAI_skillRed = [ 
	// _skills params["_accuracy","_aimingSpeed","_shake","_spotDistance","_spotTime","_courage","_reloadSpeed","_commanding","_general"];
	[0.05,0.08],  // accuracy
	[0.1,0.12],  // aiming speed
	[0.1,0.15],  // aiming shake
	[0.50,0.60], // spot distance
	[0.50,0.60], // spot time
	[0.50,0.60], // couraget
	[0.50,0.60], // reload speed
	[0.75,0.80], // commandingMenu
	[0.70,0.80] // general, affects decision making
];
GMSAI_skillGreen = [ 
	// _skills params["_accuracy","_aimingSpeed","_shake","_spotDistance","_spotTime","_courage","_reloadSpeed","_commanding","_general"];
	[0.05,0.08],  // accuracy
	[0.1,0.12],  // aiming speed
	[0.1,0.15],  // aiming shake
	[0.50,0.60], // spot distance
	[0.50,0.60], // spot time
	[0.50,0.60], // couraget
	[0.50,0.60], // reload speed
	[0.75,0.80], // commandingMenu
	[0.70,0.80] // general, affects decision making
];
GMSAI_skillOrange = [ 
	// _skills params["_accuracy","_aimingSpeed","_shake","_spotDistance","_spotTime","_courage","_reloadSpeed","_commanding","_general"];
	[0.05,0.08],  // accuracy
	[0.1,0.12],  // aiming speed
	[0.1,0.15],  // aiming shake
	[0.50,0.60], // spot distance
	[0.50,0.60], // spot time
	[0.50,0.60], // couraget
	[0.50,0.60], // reload speed
	[0.75,0.80], // commandingMenu
	[0.70,0.80] // general, affects decision making
];

GMSAI_skillbyDifficultyLevel = [GMSAI_skillBlue,GMSAI_skillRed,GMSAI_skillGreen,GMSAI_skillOrange];
GMSAI_side = GMS_side;

/*********************************
	 Messaging to Clients
*********************************/
GMSAI_useKillMessages = true;
GMSAI_useKilledAIName = true; // when true, the name of the unit killed will be included in the kill message.
/*********************************
	 Patrol Spawn Configs
*********************************/
GMSAI_releaseVehiclesToPlayers = 1;  // set to -1 to disable this feature.
GMSAI_vehicleDeleteTimer = 10; // vehicles with no live crew will be deleted at this interval after all crew are killed.
GMSAI_checkClassNames = true; // when true, class names listed in the configs will be checked against CfgVehicles, CfgWeapons, ets.
GMSAI_useCfgPricingForLoadouts = true;
GMSAI_maxPricePerItem = 1000;

GMSAI_blackListedAreas = [
	[[0,0,0],100]
]; // Add any areas you want excluded from searches for waypoints.

// These weapons would cause no damage to AI or vehicles.
// I recommend you set this to [] for militarized servers.
GMSAI_forbidenWeapons = ["LMG_RCWS","LMG_M200","HMG_127","HMG_127_APC","HMG_M2","HMG_NSVT","GMG_40mm","GMG_UGV_40mm","autocannon_40mm_CTWS","autocannon_30mm_CTWS","autocannon_35mm","LMG_coax","autocannon_30mm","HMG_127_LSV_01"];
/*********************************
	Aircraft Patrol Spawn Configs
*********************************/
// TODO: aircraft could be spread out more on the map.
GMSAI_numberOfAircraftPatrols = 5;
GMSAI_aircraftPatrolDifficulty =  [GMSAI_difficultyBlue,0.90,GMSAI_difficultyRed,0.10];
GMSAI_aircraftRespawnTime = [600,900];  //  Min, Max respawn time
GMSAI_aircraftDesapwnTime = 120;
GMSAI_aircraftChanceOfParatroops = 0.9999;  // Chance that detection of enemy players will trigger paratroopers
GMSAI_chanceOfDetection = 0.999;  // Chance that enemy players not already known to the crew but with unobstructed line of sight will be detected.
GMSAI_aircraftGunners = 3;
GMSAI_airpatrolResapwns = -1;
// treat aircraft types as weighted arrayIntersect
GMSAI_aircraftTypes = [
	"B_Heli_Transport_01_F",5,
	"B_Heli_Light_01_F",1,
	"I_Heli_light_03_unarmed_F",5,
	"B_Heli_Transport_03_unarmed_green_F",5,
	"I_Heli_light_03_F",1,
	"I_Plane_Fighter_03_AA_F",1,
	"O_Heli_Light_02_F",2,
	"B_Heli_Attack_01_F",2,
	"B_Heli_Transport_03_unarmed_F",5
];
GMSAI_aircraftPatrolDestinations = [
	"NameCity",
	"NameCityCapital",
	"NameMarine",  // ports and harbors
	"NameVillage",  // Not recommended if you have larger vehicles
	"NameLocal",  //  Includes military bases; Not recommended if you have larger vehicles
	"Airport"  // self-evident
];

GMSAI_numberOfUAVPatrols = 5;
GMSAI_UAVTypes = [  //  note that faction may matter here.

	// East 
	"O_UAV_01_F",2,  // Darter equivalent, unarmed
	"O_UAV_02_F",2, // Ababil with Scalpel Missels
	"O_UAV_02_CAS_F",2  // Ababil with Bombx

	// Weest - see CfgVehicles WEST online or in the editor
	// Independent/GUER
	//"I_UAV_01_F",1
];
GMSAI_UAVDifficulty = [GMSAI_difficultyBlue,0.40,GMSAI_difficultyRed,0.40,GMSAI_difficultyGreen,0.15,GMSAI_difficultyOrange,0.05];
GMSAI_UAVRespawnTime = [600,900]; // Min, Max
GMSAI_UAVChanceOfPParatroops = 0.99999; // Chance that detection of enemy players will trigger paratroopers

GMSAI_maxParagroups = 5;  // maximum number of groups of paratroups spawned at one time.
GMSAI_chanceParatroopsSpawn = 0.99999;
GMSAI_chancePlayerDetected = 0.999;
GMSAI_numberParatroops = [2,4]; // can be a single value (1, [1]) or a range
GMSAI_paratroopDifficulty = [GMSAI_difficultyBlue,0.40,GMSAI_difficultyRed,0.40,GMSAI_difficultyGreen,0.15,GMSAI_difficultyOrange,0.05];
GMSAI_paratroopRespawnTimer = 10;
GMSAI_paratroopAircraftTypes = [  // Note: this is a weighted array of vehicles used to carry paratroops in to locations spotted by UAVs or UGVs
	"B_Heli_Transport_01_F",5,
	"B_Heli_Light_01_F",1,
	"I_Heli_light_03_unarmed_F",5,
	"B_Heli_Transport_03_unarmed_green_F",5,
	"I_Heli_light_03_F",1,
	"O_Heli_Light_02_F",2,
	"B_Heli_Transport_03_unarmed_F",5
];

// Throws error on spawn - probably in spawnUGVpatrols as everything runs properly up till then.
GMSAI_numberOfUGVPatrols = 5;
GMSAI_UGVtypes = [  // note that faction matters here.  Not many choices in Arma at the moment.
	// Stompers
	"O_UGV_01_rcws_F",5 // east 
	//"B_UGV_01_rcws_F",5 // west 
	//"I_UGV_01_rcws_F",5 // GUER
];
GMSAI_UGVdifficulty = [GMSAI_difficultyBlue,0.60,GMSAI_difficultyRed,0.40,GMSAI_difficultyGreen,0.05,GMSAI_difficultyOrange,0.05];
GMSAI_UGVrespawnTime = [600,900];  // Min, Max
GMSAI_UGVdespawnTime = 10;
GMSAI_UGVchanceOfParatroops = 0.9999;

// TODO: Check method for distributing spawns across the map; they seem to be clustered toward the center. 
GMSAI_noVehiclePatrols = 20;
GMSAI_patroVehicleCrewCount = [4];
GMSAI_vehiclePatroDifficulty = [GMSAI_difficultyBlue,0.60,GMSAI_difficultyRed,0.40,GMSAI_difficultyGreen,0.05,GMSAI_difficultyOrange,0.05];
GMSAI_vehiclePatrolDeleteTime = 10;
GMSAI_vehiclePatrolRespawnTime = 10;
GMSAI_vehiclePatrolRespawns = -1;
GMSAI_blackListedAreasVehicles = []; //  List location names or coordinates/radius to which vehicles should not be sent. They may still pass through but will not patrol there.
GMSAI_patrolVehicles = [  // Weighted array of vehicles spawned to patrol roads and cities.
	"C_Hatchback_01_F",4,
	"C_Offroad_01_F",3,
	"B_LSV_01_armed_F",2,
	"C_SUV_01_F",2,
	"volha_Civ_01",4,
	"I_C_Offroad_02_LMG_F",2,
	"B_T_LSV_01_armed_black_F",2,
	"B_T_LSV_01_armed_olive_F",2,
	"B_T_LSV_01_armed_sand_F",2
	
];
GMSAI_vehiclePatrolDestinations = [
	"NameCity",
	"NameCityCapital",
	//"NameMarine",  // ports and harbors
	//"NameVillage",  // Not recommended if you have larger vehicles
	"NameLocal",  //  Includes military bases; Not recommended if you have larger vehicles
	"Airport"  // self-evident
];
GMSAI_blacklistedTurrets = [];  // Ammo will be removed from these
/*********************************
	Static Infantry Spawn Configs
*********************************/
GMSAI_LaunchersPerGroup = 1; // set to -1 to disable
GMSAI_launcherCleanup = true;
GMSAI_useNVG = true;
GMSAI_removeNVG = false;
GMSAI_runoverProtection = true;
GMSAI_bodyDeleteTimer = 60;

GMSAI_useDynamicSpawns = true;
GMSAI_maximumDynamicRespawns = -1;  //  Set to 0 to spawn only once. Set to -1 to have infinite respawns (default).
GMSAI_dynamicRespawnTime = 10;
GMSAI_dynamicDespawnTime = 10;
GMSAI_dynamicUnitsDifficulty = [GMSAI_difficultyBlue,0.10,GMSAI_difficultyRed,1,GMSAI_difficultyGreen,0.01,GMSAI_difficultyOrange,0.01];;  // Set how are the AI are
GMSAI_dynamicRandomGroups = [1];
GMSAI_dynamicRandomUnits = [3];
GMSAI_dynamicRandomChance = 0.999;

GMSAI_useStaticSpawns = false;
GMSAI_staticRespawns = -1;  //  Set to -1 to have infinite respawns (default). If set == 0 then there will be no spawns in towns/cities.
GMSAI_staticRespawnTime = 10;
GMSAI_staticDespawnTime = 10;
GMSAI_StaticSpawnsRandom = 5;  // Determines the number of random spans independent of cites, town, military areas, ports, airports and other:  default 25. Set == 0 do have no random spawn areas.

// GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime
GMSAI_staticVillageGroups = 1;
GMSAI_staticVillageUnitsPerGroup = [1,3];
// Difficulties are specified using a weighted array. Any number of options is available. The total relative chance does NOT have to add up to 1, but does specify the relative chance an option will be chosen.
GMSAI_staticVillageUnitsDifficulty = [GMSAI_difficultyBlue,0.90,GMSAI_difficultyRed,0.10,GMSAI_difficultyGreen,0.01,GMSAI_difficultyOrange,0.01]; // the value after each difficulty level indicates the relative chance it will be selected from the weighted array.
GMSAI_ChanceStaticVillageGroups = 0.9995;

GMSAI_staticCityGroups = 2;
GMSAI_staticCityUnitsPerGroup = [2,4];
GMSAI_staticCityUnitsDifficulty = [GMSAI_difficultyBlue,0.10,GMSAI_difficultyRed,1,GMSAI_difficultyGreen,0.01,GMSAI_difficultyOrange,0.01];
GMSAI_ChanceStaticCityGroups = 0.99950;

GMSAI_staticCapitalGroups = [2,3];
GMSAI_staticCapitalUnitsPerGroup = [2,4];
GMSAI_staticCapitalUnitsDifficulty = [GMSAI_difficultyBlue,0.10,GMSAI_difficultyRed,0.50,GMSAI_difficultyGreen,0.50,GMSAI_difficultyOrange,0.01];
GMSAI_ChanceCapitalGroups = 0.99960;

GMSAI_staticMarineGroups = [1];
GMSAI_staticMarineUnitsPerGroup = [2,3];
GMSAI_staticMarineUnitsDifficulty = [GMSAI_difficultyBlue,1,GMSAI_difficultyRed,0.50,GMSAI_difficultyGreen,0.01,GMSAI_difficultyOrange,0.01];
GMSAI_ChanceStaticMarineUnits = 0.30;

GMSAI_staticOtherGroups = [1,2];
GMSAI_staticOtherUnitsPerGroup = [2,3];
GMSAI_staticOtherUnitsDifficulty = [GMSAI_difficultyBlue,0.10,GMSAI_difficultyRed,0.50,GMSAI_difficultyGreen,0.50,GMSAI_difficultyOrange,0.01];
GMSAI_ChanceStaticOtherGroups = 0.99945;

GMSAI_staticRandomGroups = [1];
GMSAI_staticRandomUnits = [3];
GMSAI_staticRandomUnitsDifficulty = [GMSAI_difficultyBlue,0.75,GMSAI_difficultyRed,0.25,GMSAI_difficultyGreen,0.50,GMSAI_difficultyOrange,0.01];
GMSAI_staticRandomChance = 0.99940;


/********************************************/

/*
	AI configs

*/
GMSAI_useNVG = true;
