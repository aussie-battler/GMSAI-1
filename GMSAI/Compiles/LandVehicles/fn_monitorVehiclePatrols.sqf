/*
	Copyright 2020 Ghostrider-GRG-
*/

diag_log format["[GMSAI] _monitorVehiclePatrols called at %1",diag_tickTime];
for "_i" from 1 to (count GMSAI_vehiclePatrols) do
{
	if (_i > (count GMSAI_vehiclePatrols)) exitWith {};
	private _vehiclePatrol = GMSAI_vehiclePatrols deleteAt 0;
	_vehiclePatrol params["_crewGroup","_vehicle","_lastSpawned","_timesSpawned","_respawnAt"];  //,"_spawned"];
	if (_lastSpawned > 0) then
	{
		private _countUnits = {alive _x} count (units _crewGroup);
		private _countCrew = {alive _x} count (crew _vehicle);
		if ( (_countCrew > 0) && (alive _vehicle)) then
		{
			//diag_log format["_monitorVehiclePatrols: checking vehicle %1 with %2 alive crew located at %3 with speed of %4",_vehicle,{alive _x} count (crew _vehicle),getPos _vehicle,speed _vehicle];
			if (diag_tickTime > (_crewGroup getVariable "timestamp") + 600) then
			{
				//diag_log format["_monitorVehiclePatrols: vehicle %1 delayed in arriving at WP, re-directing it",_vehicle];
				(leader _crewGroup) call GMSAI_fnc_nextWaypointVehicle;
			};
			GMSAI_vehiclePatrols pushBack _vehiclePatrol;
		} else {
			//diag_log format["_monitorVehiclePatrols: vehicle patrol killed or disabled, configuring it for respawn"];
			if (_countUnits > 0 && _countCrew == 0) then // All of the units have left the vehicle, setup some monitoring for the left-over group
			{
				//diag_log format["_monitorVehiclePatrols: Some crew alive, setting them up to patrol the area idependently"];
				private _patrolArea = createMarkerLocal[format["GMSAI_remnant%1",_crewGroup],getPos _vehicle];
				private _nearPlayers = nearestObjects[position (leader _crewGroup),["Man"],150] select {isPlayer _x};
				//diag_log format["_monitorVehiclePatrols: _nearPlayers = %1",_nearPlayers];
				{
					_crewGroup reveal[_x,4];
				}forEach _nearPlayers;
				_crewGroup setVariable["target",_nearPlayers select 0];
				_patrolArea setMarkerShapeLocal "RECTANGLE";
				_patrolArea setMarkerSizeLocal [150,150];
				_crewGroup setVariable["patrolArea",_patrolArea];
				_crewGroup setVariable["despawnTime",10];
				_crewGroup setVariable["deleteAt",diag_tickTime + 10];
				//if (GMSAI_debug >= 1) then {[_crewGroup] call GMSAI_fnc_addGroupDebugMarker};				
				//GMSAI_infantryGroups pushBack [_crewGroup,_m];
				//diag_log format["_monitorVehiclePatrols: _crewGroup %1 added to GMSAI_infantryGroups",_crewGroup];
			};
			if (alive _vehicle && _countCrew == 0) then 
			{
				if (!(owner _vehicle == 2) && (ropes _vehicle isEqualTo [])) then
				{
					private _deleteAt = _vehicle getVariable "deleteAt";
					if (isNil "deleteAt") then
					{
						[_vehicle] call GMSAI_fnc_processEmptyVehicle;
						_deleteAt = diag_tickTime + GMSAI_vehiclePatrolRespawnTime;
						_vehicle setVariable["deleteAt",_deleteAt];
					};

					private _nearbyPlayers = allPlayers inAreaArray [position _vehicle, 300, 300]; 
					if !(_nearbyPlayers isEqualTo []) then
					{  //  Defer deletion when players are nearby
						_deleteAt = diag_tickTime + GMSAI_UGVdespawnTime;
						_vehicle setVariable["deleteAt",_deleteAt];						
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
			_vehiclePatrol set[4,diag_tickTime + ([GMSAI_vehiclePatrolRespawnTime] call GMS_fnc_getNumberFromRange)];
			_vehiclePatrol set[2,-1];			
		};
	} else {  // 
		//diag_log format["_monitorVehiclePatrols: _timesSpawned = %1 | _respawnAt = %2 | time = %3",_timesSpawned,_respawnAt,diag_tickTime];
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
	GMSAI_vehiclePatrols pushBack _vehiclePatrol;
};
