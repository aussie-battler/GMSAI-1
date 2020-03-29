/*
	GMSAI_fnc_monitorInactiveAreas 

	Purpose: check static spawns without AI for players and spawn AI if players are in the patrol area. 

	Parameters: none 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes:
		Need to add code to track respawns here.
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
//diag_log format["[GMSAI] running inactive area monitor at %1 with %2 inactive spawns",diag_tickTime, count GMSAI_StaticSpawns];
#define respawnAt 4
#define areaDescriptor 0
#define areaGroups 3
#define timesSpawned 5
#define GMSAI_staticDespawnDistance 300

private _spawns = [];
//[format["monitorInactiveSpawns<START>: GMSAI_StaticSpawns = %1",GMSAI_activeStaticSpawns]] call GMSAI_fnc_log;
for "_i" from 1 to (count GMSAI_StaticSpawns) do
{
	if (_i > (count GMSAI_StaticSpawns)) exitWith {};
	private _area = GMSAI_StaticSpawns deleteAt 0;
	_area params["_patrolAreaMarker","_staticAiDescriptor","_spawnType","_spawnedGroups","_respawnAt","_timesSpawned","_debugMarker"];	
	_staticAiDescriptor params["_noGroupsToSpawn","_unitsPerGroup","_difficulty","_chance","_maxRespawns","_respawnTime", "_despawnTime","_type","_isSubmerged"];	
	if !(isNil "_area") then
	{
		if ((_timesSpawned < _maxRespawns) || (_maxRespawns isEqualTo -1)) then
		{
			if (diag_tickTime > _respawnAt) then
			{
				private _players = allPlayers inAreaArray (_area select _patrolAreaMarker /*areaDescriptor*/);
				if !(_players isEqualTo []) then 
				{
					//_area params["_patrolAreaMarker","_staticAiDescriptor","_spawnType","_spawnedGroups","_respawnAt","_timesSpawned"];
					if (random(1) < (_chance) then
					{
	
						_area set[timesSpawned, (_timesSpawned + 1)];	
						private _spawns = [_patrolAreaMarker,[_noGroupsToSpawn] call GMS_fnc_getIntegerFromRange,_players] call GMS_fnc_findRandomPosWithinArea;
						private _m = "";
						private _debugMarkers = [];
						private _group = grpNull;
						if !(_spawns isEqualTo []) then
						{
							private _spawnedGroups = [];
							private _unitDifficulty = selectRandomWeighted _difficulty;								
							{
								private _groupSpawnPos = _x;
								/*
								GMSAI_fnc_spawnInfantryGroup

								params["_spawnPos", // center of the patrol area
										"_units",  // units to spawn, can be integer, [1], or range [2,3]
										"_difficulty",  //  number corresponding to he difficulty range 0-3
										["_patrolAreaMarker",""]
									];
								*/
								private ["_group"];
								if (_type isEqualTo "Man") then 
								{
									_group = [
										_difficulty
										_groupSpawnPos,
										[_unitsPerGroup] call GMS_fnc_getIntegerFromRange,
										_unitDifficulty,
										_patrolAreaMarker
									] call GMSAI_fnc_spawnInfantryGroup;
								};
								if (_type isKindOf "Car" || _type isKindOf "Tank") then 
								{
									/*
									_spawnVehiclePatrol
									params[
											"_pos",				// Random position for patrols that roam the whole map 
																	// or center of the area to be patrolled for those that are restricted to a smaller region
											["_patrolType","Map"],  // "Map" will direct the vehicle to patrol the entire map, "Region", a smaller portion of the map.
											["_blackListed",[]],  // areas to avoid within the patrol region
																// These parameters are ignored if the vehicle will patrol the entire map.
											["_center",[0,0,0]],  // center of the area to be patroled
											["_size",[200,200]],  // size of the area to be patroled, either a value or array of 2 values
											["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
											["_timeout",300],		// The time that must elapse before the antistuck function takes over.]];
											["_isSubmersible",false]
										];  
									*/
									_group = [] call GMSAI_fnc_spawnVehiclePatrol;
								};
								[format["_fnc_monitorInactiveAreas: _group spawned = %1",_group]] call GMSAI_fnc_log;
								// TODO: think about whether to have these hunt or, instead, have encounters be random.
								//[_group,_players select 0] call GMS_fnc_assignTargetAreaPatrol;
								_group setVariable["groupParameters",_staticAiDescriptor];
								_group setVariable["despawnDistance",GMSAI_staticDespawnDistance];
								_group setVariable["despawnTime",_despawnTime];
								_group setVariable["patrolAreaMarker",_patrolAreaMarker];
								_group setVariable["waypointSpeed","NORMAL"];
								_group setVariable["waypointLoiterRadius",30];
								_group setVariable["blacklistedAreas",["water"]];

								if (GMSAI_debug >= 1) then { [_group] call GMSAI_fnc_addGroupDebugMarker;};

								_group setVariable ["lastChecked",diag_tickTime];
								_spawnedGroups pushBack _group;
								//GMSAI_infantryGroups pushBack [_group,_m];
							} forEach _spawns;
							_area set [areaGroups, _spawnedGroups];
							diag_log format["_moniorINACTIVEAreas: _activeArea = %1",[_area,diag_tickTime]];
							GMSAI_activeStaticSpawns pushBack [_area,diag_tickTime];
						};
					} else {
						_area set [respawnAt,diag_tickTime + (_respawnTime)];
						GMSAI_StaticSpawns pushBack _area;
					};
				// Do something here to select locations for groups to be spawned and spawn them
				} else {
					GMSAI_StaticSpawns pushBack _area;
				};
			} else {
				// if the area passes a timestamp check the spawn more AI otherwise it should be checked again later.
				GMSAI_StaticSpawns pushBack _area;
			};
		};
	};
};
//[format["monitorInactiveSpawns<END>: GMSAI_StaticSpawns = %1",GMSAI_activeStaticSpawns]] call GMSAI_fnc_log;