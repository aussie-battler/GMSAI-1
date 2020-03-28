/*
	Copyright 2020 Ghostrider-GRG-
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
	if !(isNil "_area") then
	{
		if (GMSAI_staticRespawns == -1 || (_area select 5) < GMSAI_staticRespawns) then
		{
			if (diag_tickTime > (_area select respawnAt)) then
			{
				private _players = allPlayers inAreaArray (_area select areaDescriptor);
				if !(_players isEqualTo []) then 
				{
					//_area params["_patrolAreaMarker","_staticAiDescriptor","_spawnType","_spawnedGroups","_respawnAt","_timesSpawned"];
					if (random(1) < ((_area select 1) select 3)) then
					{
						_area params["_patrolAreaMarker","_staticAiDescriptor","_spawnType","_spawnedGroups","_respawnAt","_timesSpawned","_debugMarker"];	
						_staticAiDescriptor params["_noGroupsToSpawn","_unitsPerGroup","_difficulty","_chance"];	
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
								// params["_spawnPos","_units","_difficulty",["_patrolAreaMarker",""]];
								_group = [
									_groupSpawnPos,
									[_unitsPerGroup] call GMS_fnc_getIntegerFromRange,
									_unitDifficulty,
									_patrolAreaMarker
								] call GMSAI_fnc_spawnInfantryGroup;
								[format["_fnc_monitorInactiveAreas: _group spawned = %1",_group]] call GMSAI_fnc_log;
								// TODL: think about whether to have these hunt or, instead, have encounters be random.
								//[_group,_players select 0] call GMS_fnc_assignTargetAreaPatrol;
								_group setVariable["groupParameters",_staticAiDescriptor];
								_group setVariable["despawnDistance",GMSAI_staticDespawnDistance];
								_group setVariable["despawnTime",GMSAI_staticDespawnTime];
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
						_area set [respawnAt,diag_tickTime + (GMSAI_staticRespawnTime/2)];
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