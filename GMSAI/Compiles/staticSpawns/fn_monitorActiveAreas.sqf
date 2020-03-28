/*
	GMSAI_fnc_monitorActiveAreas 

	Purpose: monitor static spawns with AI in them 
			Make sure the hunt properly 
			delete them if no players are around after a certain time. 

	Parameters: none 

	Return: none 
	
	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
#define respawnAt 4
#define patrolAreaMarker 0
#define areaGroups 3
#define timesSpawned 5

#define GMSAI_staticDespawnDistance 300
//[format["monitorActiveAreas<START>: GMSAI_activeStaticSpawns = %1",GMSAI_activeStaticSpawns]] call GMSAI_fnc_log;
//if (true) exitWith {};

for "_i" from 1 to (count GMSAI_activeStaticSpawns) do
{
	if (_i > (count GMSAI_activeStaticSpawns)) exitWith  {};
	private _areaParameters = GMSAI_activeStaticSpawns deleteAt 0;
	//  GMSAI_StaticSpawns pushBack [_areaDescriptor, _staticAiDescriptor, GMSAI_infantry, [grpNull],respawnAt, timesSpawned];
	diag_log format["[GMSAI] monitorActiveAreas: _areaParameters = %1",_areaParameters];
	if !(isNil "_areaParameters") then
	{
		_areaParameters params["_area","_playerPresentTimeStamp"];
		private _players = allPlayers inAreaArray (_area select patrolAreaMarker);	
		//private _aliveGroups = {!(isNull _x)} count (area select areaGroups);
		private _aliveGroups = [];
		{
			[format["monitorActiveAreas: _x = %1 | typneName _x = %2",_x, typeName _x]] call GMSAI_fnc_log;
			private _group = _x;
			if (
				!(_group isEqualTo grpNull) && 
				(({alive _x} count (units _group)) > 0)
			) then 
			{
				_aliveGroups pushBack _group;
				if (GMSAI_debug >= 1) then 
				{
					[_group] call GMSAI_fnc_updateGroupDebugMarker;
				};
			};
		} forEach (_area select areaGroups);
		diag_log format["[GMSAI] monitorActiveAreas: _aliveGroups = %1 | _areaGroups = %2",_aliveGroups,_area select areaGroups];
		diag_log format["GMSAI] monitorActiveAreas: _players = %1 | _aliveGroups = %2",_players,_aliveGroups];
		if ((_players isEqualTo [])) then
		{
			diag_log format["[GMSAI] area %1 empty at %2 with _playerPresentTimeStamp = %3",_area,diag_tickTime,_playerPresentTimeStamp];
			if (diag_tickTime > (GMSAI_staticDespawnTime + _playerPresentTimeStamp)) then
			{
				diag_log format["[GMSAI] static area % deactivated at %2",_area,diag_tickTime];
				// Do something here to clean up any remaining groups and include a timestamp check.
				//  ?? not needed ?  Groups are added to // so they are already monitored; just need to manage spawning of new groups in the area here. Must be sure spawn/respawn delay > despawn time to avoid multiple groups being spawned for an area
				{
					if (GMSAI_debug >= 1) then {[_x] call GMSAI_fnc_deleteGroupDebugMarker};
					[_x] call GMS_fnc_despawnInfantryGroup;
				} forEach _aliveGroups;
				_area set[4,diag_tickTime];
				_area set[areaGroups,_aliveGroups];
				GMSAI_StaticSpawns pushBack _area;
			} else {
				GMSAI_activeStaticSpawns pushBack [_area,_playerPresentTimeStamp];
			};
		} else {
			if (_aliveGroups isEqualTo []) then
			{
				_area set[4,diag_tickTime];
				GMSAI_StaticSpawns pushBack _area;
			} else {
				GMSAI_activeStaticSpawns pushBack [_area,diag_tickTime];
			};
		};
	};
};
//[format["monitorActiveAreas<END>: GMSAI_activeStaticSpawns = %1",GMSAI_activeStaticSpawns]] call GMSAI_fnc_log;
