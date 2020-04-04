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
	buildDate = "4-3-20";
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
		class AirVehicles {
			// Everything having do with spawning and monitoring Air/UAV patrols is dealt with by these functions.
			file = "addons\GMSAI\Compiles\AirVehicles";
			class aircraftAddEventHandlers {};
			class flyInReinforcements {};		
			class initializeAircraftWaypoints {};
			class monitorAirPatrols {};  
			class monitorUAVPatrols {};					
			class monitorParatroopGroups {};				
			class nextWaypointAircraft {};			
			class processAircraftCrewHit {};
			class processAircraftCrewKilled {};	
			class processAircraftKilled {};
			class processAircraftHit {};		
			class spawnParatroops {};
			class spawnUAVPatrol {};	
			class spawnHelicoptorPatrol {};															
		};
		class dynamicSpawns {
			// Thesee functions monitor and spawn infantry groups in the vicinity of the player
			file = "addons\GMSAI\Compiles\DynamicSpawns";
			class dynamicAIManager {};
			//class monitorDynamicGroups {};			
		};
		class Functions {
			//  Core and generic support functions.
			file = "addons\GMSAI\Compiles\Functions";
			class mainThread {};  // This is a scheduler for all of the events that must happen for spawns, despawns and such.
			class monitorEmptyVehicles {};
			//class monitorDeadUnits {};  // This can be handled by GMSCore
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
		class LandVehicles {
			//  Everything related spawning/monitoring land / sea surface / SDV ehicle patrols is handled here.
			file = "addons\GMSAI\Compiles\LandVehicles";
			class initializeVehicleWaypoints {};
			class monitorVehiclePatrols {};	
			class monitorUGVPatrols {};						
			class nextWaypointVehicles {};
			//class loiterWaypointVehicles {};
			class processEmptyVehicle {};
			class spawnVehiclePatrol {};	
			class spawnUGVPatrol {};			
			class vehicleAddEventHandlers {};
			class vehicleCrewGetOut {};	
			class vehicleCrewHandleDamage {};						
			class vehicleCrewHit {};
			class vehicleCrewKilled {};
			class vehicleKilled {};
			class vehicleHandleDamage {};
			class vehicleHit {};
		};			
		class main {
			file = "addons\GMSAI\init";
			class initialize {
				postInit = 1;
			};
			class initializeConfiguration {};
		};
		class Players {
			// Things that GMSAI does to players.
			file = "addons\GMSAI\Compiles\Players";
			class rewardPlayer {};
		};	
		class staticSpawns {
			// These functions monitor and spawn infantry groups as fixed locations as players approach or leave these areas.
			file = "addons\GMSAI\Compiles\staticSpawns";
			class addBlacklistedArea {};
			class addStaticSpawn {};
			class addCustomVehicleSpawn {};
			class addCustomInfantrySpawn {};					
			class monitorActiveAreas {};
			class monitorInactiveAreas {};
		};			
		class Units {
			// Stuff that happens when events fire on units in GMSAI; some of these are in addition to EH that fire on GMSCore
			file = "addons\GMSAI\Compiles\Units";
			class infantryKilled {};
			class infantryHit {};
			class addEventHandlersInfantry {};
		};		
		class Utilities {
			// Utilities such as logging messages for GMSAI
			file = "addons\GMSAI\Compiles\Util";
			class log {};
		};
	};
};
