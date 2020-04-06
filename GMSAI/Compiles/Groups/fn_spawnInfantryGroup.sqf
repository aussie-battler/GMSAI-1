/*
	GMSAI_fnc_spawnInfantryGroup 

	Purpose: a core function to spawn a group and configure all of the parameters needed by GMS and GMSAI.
		These parameters are sorted by setVariable commands for the group. 

	Parameters:
		_spawnPos, where the group should be centered
		[_unit], number of units formated as [_min,_max], [_min] or _miin
		_difficulty, a number 1 to N corresponding to the difficulty level for the group. 
		_patrolMarker, the marker describing the area within which the group should patrol. Set this to "" to ignore all that.
	
	Returns: _group, the group that was spawned. 

	Copyright 2020 Ghostrider-GRG-

	Notes: 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 

#define GMSAI_dynamicSpawnDistance 200    //  TODO: further develop this
#define GMSAI_dynamicDespawnDistance 400  //  TODO: further develop this

params[
		"_difficulty",
		"_spawnPos", // center of the patrol area
		"_units",  // units to spawn, can be integer, [1], or range [2,3]
		"_patrolMarker"
	];

if (isNil "_patrolMarker") then {_patrolMarker =  ""; diag_log "_patrolMarker set to double quotes";};

/*

params[
		"_pos",  // center of the area in which to spawn units
		"_units",  // Number of units to spawn
		["_side",GMS_side],
		["_baseSkill",0.7],
		["_alertDistance",500], 	 // How far GMS will search from the group leader for enemies to alert to the kiillers location
		["_intelligence",0.5],  	// how much to bump knowsAbout after something happens
		["_bodycleanuptimer",600],  // How long to wait before deleting corpses for that group
		["_maxReloads",-1], 			// How many times the units in the group can reload. If set to -1, infinite reloads are available.
		["_removeLaunchers",true],
		["_removeNVG",true],
		["_minDamageToHeal",0.4],
		["_maxHeals",1],
		["_smokeShell",""]
	];

*/
private _group = [
		_spawnPos,
		[_units] call GMS_fnc_getIntegerFromRange,
		GMSAI_side,
		GMSAI_baseSkill,
		GMSA_alertDistanceByDifficulty select _difficulty,
		GMSAI_intelligencebyDifficulty select _difficulty,
		GMSAI_bodyDeleteTimer,
		GMSAI_maxReloadsInfantry,
		GMSAI_launcherCleanup,
		GMSAI_removeNVG,
		GMSAI_minDamageForSelfHeal,
		GMSAI_maxHeals,
		GMSAI_unitSmokeShell  
	] call GMS_fnc_spawnInfantryGroup;

_group setVariable["difficulty",_difficulty];

[_group,GMSAI_skillbyDifficultyLevel select _difficulty] call GMS_fnc_setupGroupSkills;  // TODO: revisit this once a system for skills is determined - simpler the better
[_group, GMSAI_unitLoadouts select _difficulty, GMSAI_LaunchersPerGroup, GMSAI_useNVG] call GMS_fnc_setupGroupGear;
[_group,_difficulty,GMSAI_money] call GMS_fnc_setupGroupMoney;

#define waypointTimeoutInfantryPatrols 180

if !(_patrolMarker isEqualTo "") then // setup waypoints using the information stored in the marker 
{
	[
		_group,
		GMSAI_blackListedAreas,
		_patrolMarker,
		waypointTimeoutInfantryPatrols
	] call GMS_fnc_initializeWaypointsAreaPatrol;
};
_group