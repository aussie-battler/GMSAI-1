/*
	GMSAI_fnc_dropReinforcements 

	Purpose: drop a group at a set location by parachutes. 

	Parameters: 
		_group, the group to be airdroped 
		_aircraft, the aircraft from which to release them 
		_target, the player targetd by these reinforcements 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes: this is intended to be used to bring in paras when a UAV detects a player and requests reinforcements.

	TODO: Figure out where these are dropped and make sure they are monitored.
	TODO: Add an area for them and add that area to those with active patrol monitoring
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_flightCrewGroup","_aircraft","_target"];
[[format["dropReinforcements called: _group = %1 | _aircraft = %2 | _target = %3",_flightCrewGroup,_aircraft,_target]]] call GMSAI_fnc_log;

private _dropPos = _flightCrewGroup getVariable "dropPos"; // the drop pos would be near the location of the flight crew when reinforcements are called in. 
private _difficulty = selectRandomWeighted GMSAI_paratroopDifficulty;
private _group = [
	[0,0,0],
	([GMSAI_numberParatroops] call GMS_fnc_getIntergerFromRange),
	GMS_side,
	GMSAI_baseSkilByDifficulty select _difficulty,
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
// TODO: Add GMSAI Event Handlers when these are ready.
[_group,GMSAI_unitDifficulty select (_difficulty)] call GMS_fnc_setupGroupSkills;
[_group, GMSAI_unitLoadouts select _difficulty, 0 /* launchers per group */, GMSAI_useNVG] call GMS_fnc_setupGroupGear;
[_group,_difficulty,GMSAI_money] call GMS_fnc_setupGroupMoney;
//[_group,GMSAI_bodyDeleteTimer] call GMS_fnc_setGroupBodyDespawnTime;
//[_group] call GMSAI_fnc_addEventHandlersInfantry;
GMSAI_paratroopGroups pushBack _group;

[[format["dropReinforcements: _group %1",_group]]] call GMSAI_fnc_log;

_group reveal[_target,4];
_group setVariable["target",_target];
_group setVariable["targetGroup",group _target];
// spawn this so other functions of GMSAI are not held up.
[_group,_dropPos,_target] call GMS_fnc_dropParatroops;

// Set a debug marker if needed - use the default setting of "Man" here 
if (GMSAI_debug >= ) then 
{
	[_group] call GMSAI_fnc_addGroupDebugMarker;
};

// Add a patrol area and send this group to the monitorActieAreas module 
private "_m";
if (GMSAI_debug >= 1) then 
{
	[_group] call GMSAI_fnc_addGroupDebugMarker;
	_m setMarkerShape "RECTANGLE";
	_m setMarkerSize [200,200];
	_m setMarkerColor "COLORRED";
	_m setMarkerAlpha = 0.5;
	_m setMarkerBrush = "GRID";
} else {
	_m = createMarkerLocal[format["paraGroup%1",diag_tickTime],_dropPos];
	_m setMarkerShapeLocal "RECTANGLE";
	_m setMarkerSizeLocal [200,200];
};

// _staticAiDescriptor params["_noGroupsToSpawn","_unitsPerGroup","_difficulty","_chance","_maxRespawns","_respawnTime", "_despawnTime","_type","_isSubmerged"];	
private _descriptor = [1,count(units _group),_group getVariable "difficulty",0,0,0,120,"Man",false]
// 	_area params["_patrolAreaMarker","_staticAiDescriptor","_spawnType","_spawnedGroups","_respawnAt","_timesSpawned"];	
// GMSAI_StaticSpawns pushBack [_areaDescriptor, _staticAiDescriptor, GMSAI_infantry, [grpNull],respawnAt, timesSpawned];
private _area = [_m,_descriptor,[_group],GMSAI_infantry,100000,1];

GMSAI_activeStaticSpawns pushBack [_area,diag_tickTime];
(leader _group) call GMS_fnc_nextWaypointAreaPatrol;



