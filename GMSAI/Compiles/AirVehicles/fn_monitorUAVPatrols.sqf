/*
	GMSAI_fnc_monitorUAVPatrols 

	Purpose: monitor UAV patrols, check if the are stuck or out of bounds, deal with this if so. 

	Parameters: None 

	Returns: None 

	Copyright 2020 Ghostrider-GRG-

	Notes:
		TODO: consider additional targeting commands as specified in _monitorAirPatrols
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
//diag_log format["[GMSAI] _monitorUAVPatrols called at %1",diag_tickTime];
// 
for "_i" from 1 to (count GMSAI_uavPatrols) do
{
	if (_i > (count GMSAI_uavPatrols)) exitWith {};
	private _uavPatrol = GMSAI_uavPatrols deleteAt 0;
	_uavPatrol params["_crewGroup","_aircraft","_lastSpawned","_timesSpawned","_respawnAt"];  //,"_spawned"];
	if (_lastSpawned > 0) then
	{
		if (!(_crewGroup isEqualTo grpNull) && !(_aircraft isEqualTo objNull) && {alive _x} count (crew _aircraft) > 0) then
		{
			if (diag_tickTime > (_crewGroup getVariable "timestamp") + 600) then
			{
				(leader _crewGroup) call GMSAI_fnc_nextWaypointAircraft;
			};
			//  Do a check for spawning paratroops
			[_crewGroup,_aircraft] spawn GMSAI_fnc_spawnParatroops;

		} else {
			_uavPatrol set[4,diag_tickTime + ([GMSAI_UAVRespawnTime] call GMS_fnc_getNumberFromRange)];
			_uavPatrol set[2,-1];
		};
		GMSAI_uavPatrols pushBack _uavPatrol;
	} else {
		if (GMSAI_uavPatrolResapwns == -1 || _timesSpawned <= GMSAI_uavPatrolResapwns) then
		{
			if (_respawnAt > -1 && diag_tickTime > _respawnAt) then
			{
				private _pos = [nil,["water"] /*+ any blacklisted locations*/] call BIS_fnc_randomPos;

				// Keep this way to provide randomness to the map-wide roaming UAVs
				private _newPatrol = [(selectRandomWeighted GMSAI_UAVTypes), _pos] call GMSAI_fnc_spawnUAVPatrol;
				_uavPatrol set[0,_newPatrol select 0];
				_uavPatrol set[1,_newPatrol select 1];
				_uavPatrol set[2,diag_tickTime];
				_uavPatrol set[3,_timesSpawned + 1];
				//_uavPatrol set[4,-1]; // reset last spawned							
				//_uavPatrol set[5,-1];
			};
			GMSAI_uavPatrols pushBack _uavPatrol;
		};
	};
};


