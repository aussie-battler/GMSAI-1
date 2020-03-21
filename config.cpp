/*
	By Ghostrider [GRG]
	Copyright 2016
	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
class GMSAAI_Build {
	build = "0.13";
	buildDate = "9-24-19";
};
class CfgPatches {
	class GMSAI {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"GMSCore"};
	};
};
class CfgFunctions {
	class GMSAI {
		class main {
			file = "addons\GMSAI\init";
			class initialize {
				postInit = 1;
			};
		};
		class Players {
			// Things that GMSAI does to players.
			file = "addons\GMSAI\Compiles\Players";
			class rewardPlayer {};
		};
		class Units {
			// Stuff that happens when events fire on units in GMSAI; some of these are in addition to EH that fire on GMSCore
			file = "addons\GMSAI\Compiles\Units";
		   //class EH_InfantryKilled {};
			//class EH_InfantryHit {};
			//class EH_infantryReloaded {};	
			class infantryKilled {};
			//class processUnitKill {};
			class infantryHit {};
			class addEventHandlersInfantry {};
		};
		class Groups {
			file = "addons\GMSAI\Compiles\Groups";

			class addGroupDebugMarker {};
			class deleteGroupDebugMarker {};
			class getGroupDebugMarker {};
			class monitorGroupDebugMarkers {};
			class spawnInfantryGroup {};			
			class updateGroupDebugMarker {};
		};
		class AirVehicles {
			// Everything having do with spawning and monitoring Air/UAV patrols is dealt with by these functions.
			file = "addons\GMSAI\Compiles\AirVehicles";
			class flyInParatroops {};		
			class initializeAircraftWaypoints {};
			class monitorAirPatrols {};  
			class monitorUAVPatrols {};					
			class monitorParatroopSpawns {};				
			class nextWaypointAircraft {};			
			class processAircraftCrewHit {};
			class processAircraftCrewKilled {};	
			class processAircraftKilled {};
			class processAircraftHit {};		
			class spawnParatroops {};
			class spawnUAVPatrol {};	
			class spawnHelicoptorPatrol {};															
		};
		class LandVehicles {
			//  Everything related spawning/monitoring land / sea surface / SDV ehicle patrols is handled here.
			file = "addons\GMSAI\Compiles\LandVehicles";
			class initializeVehicleWaypoints {};
			class monitorVehiclePatrols {};	
			class monitorUGVPatrols {};						
			class nextWaypointVehicles {};
			//class loiterWaypointVehicles {};
			class vehicleCrewHit {};
			class vehicleCrewKilled {};
			class vehicleCrewHandleDamage {};
			class vehicleCrewGetOut {};
			class processEmptyVehicle {};						
			class vehicleHit {};
			class vehicleKilled {};
			class vehicleHandleDamage {};
			class spawnVehiclePatrol {};	
			class spawnUGVPatrol {};
		};
		class Initialization {
			// Initialization of static spawn points is handled by these functions
			file = "addons\GMSAI\Compiles\Initialization";
			class initializeStaticSpawnsForLocations {};
			class initializeRandomSpawnLocations {};				
			class initializeAircraftPatrols {};
			class initializeUAVPatrols {};		
			class initializeUGVPatrols {};	
			class initializeVehiclePatrols {};
		};
		class Functions {
			//  Core and generic support functions.
			file = "addons\GMSAI\Compiles\Functions";
			class addStaticSpawnInfantry {};
			class mainThread {};  // This is a scheduler for all of the events that must happen for spawns, despawns and such.
			class monitorEmptyVehicles {};
			class monitorDeadUnits {};  // This can be handled by GMSCore
		};
		class staticSpawns {
			// These functions monitor and spawn infantry groups as fixed locations as players approach or leave these areas.
			file = "addons\GMSAI\Compiles\staticSpawns";		
			class monitorActiveAreas {};
			class monitorInactiveAreas {};
		};
		class dynamicSpawns {
			// Thesee functions monitor and spawn infantry groups in the vicinity of the player
			file = "addons\GMSAI\Compiles\DynamicSpawns";
			class dynamicAIManager {};				
		};
		class Utilities {
			// Utilities such as logging messages for GMSAI
			file = "addons\GMSAI\Compiles\Util";
			class log {};
		};
	};
};


/*  Need to move this to a separate file
    and possibly a separate pbo 
*/

class CfgGMSAI {
	#define true 1
	#define false 0
	#define nighttime 1
	#define always 2

	class CfgSetup {
		checkClassnames = true;
		usepricelistsforloadouts = true;
		maxPricePerItem = 1000;  // use to keep from adding really valuable stuff to units.
		blacklistedGear[] = {
			// List any uniforms, weapons, optics, etc you do not want AI to carry
		};
		blacklistedAreas[] = {
			// enter as {{x,y,z},radius},
			// no comma after the last one of course
		};
		forbidenWeapons[] = {
			// kills with these weapons will be disallowed
		};
		disableTurrets[] = {
			// disable these types of turrets when AI vehicles spawn
		};
		releaseVehiclesToPlayers = true;
		vehicleDespawnTime = 10; 

	};

	class CfgAircraftPatrols {
		numberAirPatrols = 1;
		respawnTime[] = {600,900};
		chancePlayerDetected = 0.5;
		chanceReinforcements = 0.5;
		aircraftCrew = 3;
		aircraftRespawns = 3;
		aircraftTypes[] = {
			// weighted arrah
			// formate: classname, weight			
			"B_Heli_Transport_01_F",5,
			"B_Heli_Light_01_F",1,
			"I_Heli_light_03_unarmed_F",5,
			"B_Heli_Transport_03_unarmed_green_F",5,
			"I_Heli_light_03_F",1,
			"I_Plane_Fighter_03_AA_F",1,
			"O_Heli_Light_02_F",2,
			"B_Heli_Attack_01_F",2,
			"B_Heli_Transport_03_unarmed_F",5
		};
		destinations[] = {
			"NameCity",
			"NameCityCapital",
			"NameMarine",  // ports and harbors
			"NameVillage",  // Not recommended if you have larger vehicles
			"NameLocal",  //  Includes military bases; Not recommended if you have larger vehicles
			"Airport"  // self-evident
		};
		money[] = {100, 200, 300, 400};  // amount added for difficulties 1..4
	};

	class CfgUAVpatrols {
		noUAVpatrols = 1;
		UAVchancePlayerDetected = 0.5;
		UAVchanceReinforcements = 0.5;
		UAVrespawnTime[] = {600,900};
		UAVtypes[] = {
			// weighted arrah
			// formate: classname, weight
			//  note that faction may matter here.
			// East 
			"O_UAV_01_F",2,  // Darter equivalent, unarmed
			"O_UAV_02_F",2, // Ababil with Scalpel Missels
			"O_UAV_02_CAS_F",2  // Ababil with Bombx

			// Weest - see CfgVehicles WEST online or in the editor
			// Independent/GUER
			//"I_UAV_01_F",1
		};
	};
	
	class CfgUGVPatrols {
		numberUGFPatrols = 1;
		UGVvehicleTypes[] = 
		{// note that faction matters here.  Not many choices in Arma at the moment.
			// Stompers
			"O_UGV_01_rcws_F",5 // east 
			//"B_UGV_01_rcws_F",5 // west 
			//"I_UGV_01_rcws_F",5 // GUER
		}; 
		respawnTime[] = {600,900};
		chancePlayersDetected = 0.5;
		chanceReinforcements = 0.5;
	};

	class CfgVehiclePatrols {

		vehicleDeleteTimer = 10;
		numberVehiclePatrols = 1;
		patrolVehicleCrewCount = 4;
		vehiclePatrolDeleteTime = 10;
		vehiclePatrolRespawnTime[] = {600,900};
		vehiclePatrolrespawns = -1;
		patrolVehicles[] = {
			// format:
			// class name, weight
			"C_Hatchback_01_F",4,
			"C_Offroad_01_F",3,
			"B_LSV_01_armed_F",2,
			"C_SUV_01_F",2,
			"volha_Civ_01",4,
			"I_C_Offroad_02_LMG_F",2,
			"B_T_LSV_01_armed_black_F",2,
			"B_T_LSV_01_armed_olive_F",2,
			"B_T_LSV_01_armed_sand_F",2
		};

		vehiclePatrolDestinations[] = // kinds of map locations to which vehicle patrols travel 
		{
			"NameCity",
			"NameCityCapital",
			//"NameMarine",  // ports and harbors
			//"NameVillage",  // Not recommended if you have larger vehicles
			"NameLocal",  //  Includes military bases; Not recommended if you have larger vehicles
			"Airport"  // self-evident
		};
		money[] = {50, 100, 150, 200};
	};

	class CfgReinforcements {
		maxParagroups = 5;  // maximal number of reinforcement/para groups spawned at one time.
		numberUnits[] = {2,4};  // min/max, enter the same value to have this constant. 
		respawnTimer = 120; // minimum time between reinforcements within 1000 m of a player 
		despawnTimer = 120; // time after which troops despawn if all players have left the area (1000 m?)
		flyinWith[] = { // aircraft used to fly in the troops
		// Note: this is a weighted array of vehicles used to carry paratroops in to locations spotted by UAVs or UGVs
			"B_Heli_Transport_01_F",5,
			"B_Heli_Light_01_F",1,
			"I_Heli_light_03_unarmed_F",5,
			"B_Heli_Transport_03_unarmed_green_F",5,
			"I_Heli_light_03_F",1,
			"O_Heli_Light_02_F",2,
			"B_Heli_Transport_03_unarmed_F",5
		};
	};

	class CfgUnitConfiguration { 
		launchersPerGroup = 1;
		launcherCleanupOnDeath = true;
		useNVG = true;
		removeNVGonDeath = true;
		bodyDeleteTimer = 60;
		money[] = {8, 12, 16, 20};
		alertDistance[] = {200, 350, 500, 700};
		intelligence[] = {0.1, 0.3, 0.5, 0.7};
	};

	class CfgDynamicSpawns {
		useDynamicSpawns = false;
		maximumDynamicSpawns = 5;  // maximum on server at any time.
		respawnTime[] = {600,900}; // time for the patrol to resapwn and retarget a player.
		despawnTime = 120;
		groups[] = {1,1};
		unitsPerGroup[] = {2,3};
		chanceRandomSpawn = 0.4;  // the chance that a dynamically spawned patrol will spawn in the vicinity of the player.
	};

	class CfgStaticSpawns {
		// These occur in fixed locations:
		// eithe randomly across the map
		// or in cites, towns, military bases and so forth.
		useStaticSpawns = true;
		noStaticRespawns = -1;  // set to -1 to have infinite respawns.
		respawnTime[] = {600,600};
		despawnTime = 120;
		numberRandomStaticSpawns = -1; // set to -1 to disable these

		class CfgStaticVillage {
			groups[] = {1,1};  // groups spawned in the location; can be a range, set to the same number to keep this always the same
			unitsPerGroup[] = {2,3}; // unist spawned per group; setting as above
			difficulty[] = {};
			chanceGroupsSpawned = 0.3;
		}
		
		class CfgStaticCity {
			groups[] = {2,2};
			unitsPerGroup[] = {3,4};
			difficulty[] = {};
			chanceGroupsSpawned = 0.4;
		};

		class CfgCapital {
			groups[] = {3,4};
			unitsPerGroup[] = {3,4};
			difficulty[] = {};
			chanceGroupsSpawned = 0.6;
		}

		class CFgMarine {
			groups[] = {1,1};
			unitsPerGroup[] = {2,2};
			difficulty[] = {};
			chanceGroupsSpawned = 0.5;
		}

		class CfgOther {
			// military and smallish locations not otherwise captured
			groups[]={2,3};
			unitsPerGroup[] = {2,2};
			difficulty[] = {};
			chanceGroupsSpawned = 0.4;
		}

		class CfgRandom {
			groups[] = {1,2};
			unitsPerGroup[] = {2,3};
			difficulty[] = {};
			chanceGroupsSpawned = 0.3;
		};
	};
	class CfgSkills {
		defaultBaseSkill = 0.7;
		baseSkillByDifficulty[] = {
			0.5, // blue 
			0.6,
			0.75,
			0.9
		};
		skillsLevel_1[] = {
			{0.05,0.08},  // accuracy
			{0.1,0.12},  // aiming speed
			{0.1,0.15},  // aiming shake
			{0.50,0.60}, // spot distance
			{0.50,0.60}, // spot time
			{0.50,0.60}, // couraget
			{0.50,0.60}, // reload speed
			{0.75,0.80}, // commandingMenu
			{0.70,0.80} // general, affects decision making
		};
		skillsLevel_2[] = {
			{0.05,0.08},  // accuracy
			{0.1,0.12},  // aiming speed
			{0.1,0.15},  // aiming shake
			{0.50,0.60}, // spot distance
			{0.50,0.60}, // spot time
			{0.50,0.60}, // couraget
			{0.50,0.60}, // reload speed
			{0.75,0.80}, // commandingMenu
			{0.70,0.80} // general, affects decision making
		};
		skillsLevel_3[] = {
			{0.05,0.08},  // accuracy
			{0.1,0.12},  // aiming speed
			{0.1,0.15},  // aiming shake
			{0.50,0.60}, // spot distance
			{0.50,0.60}, // spot time
			{0.50,0.60}, // couraget
			{0.50,0.60}, // reload speed
			{0.75,0.80}, // commandingMenu
			{0.70,0.80} // general, affects decision making
		};
		skillsLevel_4[] = {
			{0.05,0.08},  // accuracy
			{0.1,0.12},  // aiming speed
			{0.1,0.15},  // aiming shake
			{0.50,0.60}, // spot distance
			{0.50,0.60}, // spot time
			{0.50,0.60}, // couraget
			{0.50,0.60}, // reload speed
			{0.75,0.80}, // commandingMenu
			{0.70,0.80} // general, affects decision making
		};
		skillsLevel_5[] = {
			{0.05,0.08},  // accuracy
			{0.1,0.12},  // aiming speed
			{0.1,0.15},  // aiming shake
			{0.50,0.60}, // spot distance
			{0.50,0.60}, // spot time
			{0.50,0.60}, // couraget
			{0.50,0.60}, // reload speed
			{0.75,0.80}, // commandingMenu
			{0.70,0.80} // general, affects decision making
		};
		skillsLevel_6[] = {
			{0.05,0.08},  // accuracy
			{0.1,0.12},  // aiming speed
			{0.1,0.15},  // aiming shake
			{0.50,0.60}, // spot distance
			{0.50,0.60}, // spot time
			{0.50,0.60}, // couraget
			{0.50,0.60}, // reload speed
			{0.75,0.80}, // commandingMenu
			{0.70,0.80} // general, affects decision making
		};
		skillsLevel_7[] = {
			{0.05,0.08},  // accuracy
			{0.1,0.12},  // aiming speed
			{0.1,0.15},  // aiming shake
			{0.50,0.60}, // spot distance
			{0.50,0.60}, // spot time
			{0.50,0.60}, // couraget
			{0.50,0.60}, // reload speed
			{0.75,0.80}, // commandingMenu
			{0.70,0.80} // general, affects decision making
		};
		skillsLevel_8[] = {
			{0.05,0.08},  // accuracy
			{0.1,0.12},  // aiming speed
			{0.1,0.15},  // aiming shake
			{0.50,0.60}, // spot distance
			{0.50,0.60}, // spot time
			{0.50,0.60}, // couraget
			{0.50,0.60}, // reload speed
			{0.75,0.80}, // commandingMenu
			{0.70,0.80} // general, affects decision making
		};								
	};
	class CfgPlayerNotifications {
		useKillMessages = true;
		useKilledAIName = true;
		useRadioMessages = true;
	};
};