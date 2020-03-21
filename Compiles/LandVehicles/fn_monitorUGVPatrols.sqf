diag_log format["[GMSAI] _monitorUGVPatrols called at %1",diag_tickTime];
for "_i" from 1 to (count GMSAI_UGVPatrols) do
{
	if (_i > (count GMSAI_UGVPatrols)) exitWith {};
	private _vehiclePatrol = GMSAI_UGVPatrols deleteAt 0;
	_vehiclePatrol params["_crewGroup","_vehicle","_lastSpawned","_timesSpawned","_respawnAt"];  //,"_spawned"];
	if (_lastSpawned > 0) then
	{
		private _countUnits = {alive _x} count (units _crewGroup);
		private _countCrew = {alive _x} count (crew _vehicle);
		if ( (_countCrew > 0) && (alive _vehicle)) then
		{
			if (diag_tickTime > (_crewGroup getVariable "timestamp") + 600) then
			{
				//diag_log format["_monitorUGVPatrols: vehicle %1 delayed in arriving at WP, re-directing it",_vehicle];
				(leader _crewGroup) call GMSAI_fnc_nextWaypointVehicle;
			};
			GMSAI_UGVPatrols pushBack _vehiclePatrol;
		} else {
			if (_countCrew == 0 && alive _vehicle) then 
			{
				
				if (!(isUAVConnected _vehicle) && (ropes _vehicle isEqualTo [])) then
				{
					private _deleteAt = _vehicle getVariable "GMSAI_deleteAt";
					if (isNil "GMSAI_deleteAt") then
					{
						[_vehicle] call GMSAI_fnc_processEmptyVehicle;
						_deleteAt = diag_tickTime + GMSAI_UGVdespawnTime;
						_vehicle setVariable["GMSAI_deleteAt",_deleteAt];
					};
					private _nearbyPlayers = allPlayers inAreaArray [position _vehicle, 300, 300]; 
					if !(_nearbyPlayers isEqualTo []) then
					{  //  Defer deletion when players are nearby
						_deleteAt = diag_tickTime + GMSAI_UGVdespawnTime;
						_vehicle setVariable["GMSAI_deleteAt",_deleteAt];						
					};
					if (diag_tickTime > _deleteAt) then
					{
						{deleteVehicle _x} forEach (crew _vehicle);
						deleteVehicle _vehicle;
						_vehiclePatrol set[4,diag_tickTime + ([GMSAI_vehiclePatrolRespawnTime] call GMS_fnc_getNumberFromRange)];
						_vehiclePatrol set[2,-1];						
					};			
				};				
			};
		};
	} else {  // 
		//diag_log format["_monitorUGVPatrols: _timesSpawned = %1 | _respawnAt = %2 | time = %3",_timesSpawned,_respawnAt,diag_tickTime];
		if (GMSAI_vehiclePatrolRespawns == -1 || _timesSpawned <= GMSAI_vehiclePatrolRespawns) then
		{
			if (_respawnAt > -1 && diag_tickTime > _respawnAt) then
			{
				private _pos = [0,0];
				while {_pos isEqualTo [0,0]} do
				{
					_pos = [nil,["water"]] call BIS_fnc_randomPos;
					//diag_log format["[GMSAI] _initializeVehiclePatrols: _pos = %1",_pos];
				};
				// TODO: Add remaing parameters here				
				private _newPatrol = [_pos] call GMSAI_fnc_spawnVehiclePatrol;
				_vehiclePatrol set[0,_newPatrol select 0];
				_vehiclePatrol set[1,_newPatrol select 1];
				_vehiclePatrol set[2,diag_tickTime];
				_vehiclePatrol set[3,_timesSpawned + 1];
			};
		};
	};
	GMSAI_UGVPatrols pushBack _vehiclePatrol;
};
