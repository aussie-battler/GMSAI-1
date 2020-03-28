/*
	GMSAI_fnc_initializeStaticVehicleSpawns 

	Purpose: set up spawns for vehicle patrols that work within prespecified areas. 

	Parameters: None 

	Returns: None 
	
	Copyright 2020 Ghostrider-GRG-

	Notes: 
		- not sure what this was supposed to do.
		- It should be setting up area patrols for land vehicles which are user defined
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
		private _vehiclePatrol = [_pos] call GMSAI_fnc_spawnVehiclePatrol;
		//diag_log format["[GMSAI] _initializeVehiclePatrols: _vehiclePatrol = %1",_vehiclePatrol];
		//  _vehiclePatrol params["_crewGroup","_vehicle","_lastSpawned","_timesSpawned","_respawnAt"];  //,"_spawned"];
		GMSAI_vehiclePatrols pushBack [_vehiclePatrol select 0,_vehiclePatrol select 1,diag_tickTime,0,-1,-1];
	};
};