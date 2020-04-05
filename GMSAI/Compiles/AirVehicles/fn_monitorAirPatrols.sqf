/*
	GMSAI_fnc_monitorAirPatrols 

	Purpose: ensure that air patrols do not get 'stuck' finding a waypoint 
			and are recalled when the wander too far from the patrol area
	
	Parameters: None 

	Returns: None 

	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
[format["[GMSAI] _monitorAirPatrols called at %1 for %2 ACTIVE Air Patrols",diag_tickTime, count GMSAI_airPatrols]] call GMSAI_fnc_log;
for "_i" from 1 to (count GMSAI_airPatrols) do
{
	if (_i > (count GMSAI_airPatrols)) exitWith {};
	private _airPatrol = GMSAI_airPatrols deleteAt 0;
	_airPatrol params["_crewGroup","_aircraft","_lastSpawned","_timesSpawned","_respawnAt"];  //,"_spawned"];
	if (_lastSpawned > 0) then
	{
		// an aircraft patrol is active
		if (!(_crewGroup isEqualTo grpNull) && !(_aircraft isEqualTo objNull) && {alive _x} count (crew _aircraft) > 0) then
		{
			// Check if the aircraft is 'stuck' and if so set a new waypoint
			if (diag_tickTime > (_crewGroup getVariable "timestamp") + 600) then
			{
				(leader _crewGroup) call GMSAI_fnc_nextWaypointAircraft;
			};
			//  Do a check for spawning paratroops
			[_crewGroup,_aircraft] spawn GMSAI_fnc_spawnParatroops;
			
		} else {
			// handle the case where aircraft has been destroyed or crew killed.
			_airPatrol set[4,diag_tickTime + ([GMSAI_aircraftRespawnTime] call GMS_fnc_getNumberFromRange)];
			_airPatrol set[2,-1];
						
		};
		GMSAI_airPatrols pushBack _airPatrol;		
	} else {
		// check if further spawns / respans are allowed
		if (GMSAI_airpatrolResapwns == -1 || _timesSpawned <= GMSAI_airpatrolResapwns) then
		{
			if (_respawnAt > -1 && diag_tickTime > _respawnAt) then
			{
				private _pos = [nil,["water"] /*+ any blacklisted locations*/] call BIS_fnc_randomPos;

				// Keep this way to provide randomness for map-wide roaming aircraft				
				private _newPatrol = [(selectRandomWeighted GMSAI_aircraftTypes), _pos] call GMSAI_fnc_spawnHelicoptorPatrol;
				_airPatrol set[0,_newPatrol select 0];
				_airPatrol set[1,_newPatrol select 1];
				_airPatrol set[2,diag_tickTime];
				_airPatrol set[3,_timesSpawned + 1];
				//_airPatrol set[4,-1]; // reset last spawned							
				//_airPatrol set[5,-1];
			};
			GMSAI_airPatrols pushBack _airPatrol;
		};
	};
};
