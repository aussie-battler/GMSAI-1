/*
	GMSAI_fnc_initializeVehiclePatrols 

	Purpose: initialize vehicle patrols that run beteween locations and could span the whole map. 

	Parameters: none 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes: 
		TODO: think about area-based versions of this script
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
diag_log format["[GMSAI] _initializeVehiclePatrols: Begining script | GMSAI_noVehiclePatrols = %1",GMSAI_noVehiclePatrols];
private _blacklistedAreas = ["water"];
for "_i" from 1 to GMSAI_noVehiclePatrols do
{
	private _pos = [0,0];
	while {_pos isEqualTo [0,0]} do
	{
		_pos = [nil,_blacklistedAreas] call BIS_fnc_randomPos;
		//diag_log format["[GMSAI] _initializeVehiclePatrols: _pos = %1",_pos];
	};
	if !(_pos isEqualTo [0,0]) then
	{
		private _vehiclePatrol = [
			[selectRandomWeighted GMSAI_vehiclePatroDifficulty] call GMS_fnc_getIntegerFromRange,
			selectRandomWeighted GMSAI_patrolVehicles,
			_pos
		] call GMSAI_fnc_spawnVehiclePatrol;
		//diag_log format["[GMSAI] _initializeVehiclePatrols: _vehiclePatrol = %1",_vehiclePatrol];
		//  _vehiclePatrol params["_crewGroup","_vehicle","_lastSpawned","_timesSpawned","_respawnAt"];  //,"_spawned"];
		GMSAI_vehiclePatrols pushBack [_vehiclePatrol select 0,_vehiclePatrol select 1,diag_tickTime,0,-1,-1];
	};
};