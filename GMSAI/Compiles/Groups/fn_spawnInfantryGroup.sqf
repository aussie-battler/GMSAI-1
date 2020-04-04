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
// TODO add difficulty-based alert distance and intelligence
#define GMSAI_dynamicSpawnDistance 200    //  TODO: further develop this
#define GMSAI_dynamicDespawnDistance 400  //  TODO: further develop this
#define GMSAI_alertAIDistance 300  //  TODO: further develop this
#define GMSAI_intelligence 0.5  //  TODO: further develop this
params[
		"_difficulty",
		"_spawnPos", // center of the patrol area
		"_units",  // units to spawn, can be integer, [1], or range [2,3]
		"_patrolMarker"
	];

if (isNil "_patrolMarker") then {_patrolMarker =  ""; diag_log "_patrolMarker set to double quotes";};
[format["GMSAI_fnc_spawnInfantryGroup: _this = %1",_this],"information"] call GMSAI_fnc_log;
{
	[format["GMSAI_fnc_spawnInfantryGroup: _this select %1 = %2",_forEachIndex,_x],"information"] call GMSAI_fnc_log;
}forEach _this;

diag_log format[" _GMSAI_fnc_spawnInfantryGroup: _difficulty = %1 | _spawnPos = %2 | _units = %3 | _patrolMarker = %4",_difficulty,_spawnPos,_units,_patrolMarker];

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
		GMSAI_alertAIDistance,
		GMSAI_intelligence,
		GMSAI_bodyDeleteTimer,
		GMSAI_maxReloadsInfantry,
		GMSAI_launcherCleanup,
		GMSAI_removeNVG,
		GMSAI_minDamageForSelfHeal,
		GMSAI_maxHeals,
		GMSAI_unitSmokeShell  
	] call GMS_fnc_spawnInfantryGroup;

[format["GMSAI_fnc_spawnInfantryGroup: _group returned = %1",_group]] call GMSAI_fnc_log;
//private _unitDifficulty = selectRandomWeighted GMSAI_dynamicUnitsDifficulty;

 [_group,GMSAI_skillbyDifficultyLevel select _difficulty] call GMS_fnc_setupGroupSkills;  // TODO: revisit this once a system for skills is determined - simpler the better
[_group, GMSAI_unitLoadouts select _difficulty, GMSAI_LaunchersPerGroup, GMSAI_useNVG] call GMS_fnc_setupGroupGear;
[_group,_difficulty,GMSAI_money] call GMS_fnc_setupGroupMoney;
//[_group,GMSAI_bodyDeleteTimer] call GMS_fnc_setGroupBodyDespawnTime;
#define waypointTimeoutInfantryPatrols 180
[format["_spawnInfantryGroup: _patrolMarker = %1",_patrolMarker],"information"] call GMSAI_fnc_log;
if !(_patrolMarker isEqualTo "") then // setup waypoints using the information stored in the marker 
{
	//[_group,_patrolAreaMaker] call GMS_fnc_setWaypointPatrolAreaMarker
	[format["GMSAI_fnc_spawnInfantryGroup: _group %1: initializing waypoints",_group]] call GMSAI_fnc_log;
	[
		/*
		params["_group",  // group for which to configure / initialize waypoints
		["_blackListed",[]],  // areas to avoid within the patrol region
		["_center",[0,0,0]],  // center of the area to be patroled
		["_size",[200,200]],  // size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
		["_timeout",300]];  // The time that must elapse before the antistuck function takes over.
		*/
		_group,
		GMSAI_blackListedAreas,
		_patrolMarker,
		waypointTimeoutInfantryPatrols
	] call GMS_fnc_initializeWaypointsAreaPatrol;
};
_group