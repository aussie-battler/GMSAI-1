/*
	GMSAI_fnc_initializeUGVPatrols 

	Purpose: setup location-based UGV patrols that could roam the entire map. 

	Parameters: none 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes: 
		TODO: think about area-based functions for UGVs
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
diag_log format["[GMSAI] _initializeUGVPatrols: Begining script | GMSAI_noVehiclePatrols = %1",GMSAI_noVehiclePatrols];
private _blacklistedAreas = ["water"];
for "_i" from 1 to GMSAI_numberOfUGVPatrols do
{
	private _pos = [0,0];
	while {_pos isEqualTo [0,0]} do
	{
		_pos = [nil,_blacklistedAreas] call BIS_fnc_randomPos;
		//diag_log format["[GMSAI] _initializeUGVPatrols: _pos = %1",_pos];
	};
	if !(_pos isEqualTo [0,0]) then
	{
		private _difficulty = selectRandomWeighted GMSAI_UGVdifficulty;
		private _type = selectRandomWeighted GMSAI_UGVtypes;
		//[format["_initializeUGFPatrols: _difficulty = %1 | _type = %2",_difficulty,_type],"information"] call GMSAI_fnc_log;
		private _def = if (isNil "GMSAI_fnc_spawnUGVPatrol") then {"nil"} else {"defined"};
		[format["_initializeUGFPatrols: _def = %1 | _type = %2",_def],"information"] call GMSAI_fnc_log;
		private _UGVPatrol = [
			_difficulty,
			_type,
			_pos
		] call GMSAI_fnc_spawnUGVPatrol;
		//diag_log format["[GMSAI] _initializeUGVPatrols: _UGVPatrol = %1",_UGVPatrol];
		GMSAI_UGVPatrols pushBack [_UGVPatrol select 0,_UGVPatrol select 1,diag_tickTime,0,-1,-1];
	};
};