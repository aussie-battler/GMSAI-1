diag_log format["[GMSAI] _monitorAirPatrols called at %1 for %2 ACTIVE Air Patrols",diag_tickTime, count GMSAI_airPatrols];
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
			// conditions under which the crew would look for a player to trigger having new reinforcements brought in 
			/*
				1. number of active reinforcements < max.
					(count GMSAI_paratroopGroupsSpawned) < GMSAI_maxParagroups;
				2. there are helis in the air.
					assumed if we get this far in the script
				3. there are players within 300 m 
					 _players = nearestObjects[getPosATL (leader _crewGroup), ["Man", ]300] select {isPlayer _x};
				4. there are no reinforcements tied to that aircraft 
					private _paraGroup = _crewGroup getVariable "GMSAI_paraGroup";  //  should be nil
					private _inbound = _crewGroup getVariable "GMSAI_heliInbound";  // should be nil
				5. time elapsed since last import of reinforcements > respawn time. 
					private _respawnAt = _crewGroup getVariable["respawnParaDropAt",-1];
					if (_lastSpawned == -1) || (diag_tickTime > _respawnAt) then ... blah blah
			*/
			private _respawnAt = _crewGroup getVariable["respawnParaDropAt",-1];
			if (
				((count GMSAI_paratroopGroups) < GMSAI_maxParagroups) && 
				((_respawnAt == -1) || (diag_tickTime > _respawnAt)) && 
				(isNil "_paraGroup") && 
				(isNil "_inbound") 
			) then 
			{
				private _target = objNull;
				private _players = nearestObjects[getPosATL (leader _crewGroup), ["Man"], 300];
				{
					if (_crewGroup knowsAbout _x > 0.25) then {_target = _x};
				}
				if (isNull _target) then 
				{
					{
						private _player = _x;
						{
							if ([_x,_player] call GMS_fnc_unitCanSee) then 
							{ 
								if (random(1) < GMSAI_chanceOfDetection) then 
								{
									_playerSeen = true;
									_detectedPlayer = _x;
								};
							};
							if (_playerSeen) exitWith {};
						} forEach (units _crewGroup);
						if (_playerSeen) exitWith {};
					} forEach _players;
				};
				if !(isNull _target) then 
				{
					// conditions under which a request to fly in reinforcements might be transmitted 
					/*
						the player is recognized as an enemy or 
						one or more units in the aircraft can see the player AND random(1) < chanceOfDetection 
						When this occurs, if random(1) < chanceReinforcements then reinforcements are called in. 
						and a groupspawned flag will be added to the aircraft. 

						No further reinfircements can be called in by that aircraft untill the cooloff period is completed, meaning that time > respawnAt.
					*/ 

					if (random(1) < GMSAI_aircraftChanceOfParatroops) then 
					{
						[_crewGroup,_target] call GMSAI_fnc_flyInReinforcements;
					};
				};
			};
			// check if it is stuck
			if (diag_tickTime > (_crewGroup getVariable "timestamp") + 600) then
			{
				(leader _crewGroup) call GMSAI_fnc_nextWaypointAircraft;
			};
			// return the aircraft to the list.				
			GMSAI_airPatrols pushBack _airPatrol;
		} else {
			// handle the case where aircraft has been destroyed or crew killed.
			_airPatrol set[4,diag_tickTime + [GMSAI_aircraftRespawnTime] call GMS_fnc_getNumberFromRange
			];
			_airPatrol set[2,-1];
			GMSAI_airPatrols pushBack _airPatrol;			
		};
	} else {
		// check if further spawns / respans are allowed
		if (GMSAI_airpatrolResapwns == -1 || _timesSpawned <= GMSAI_airpatrolResapwns) then
		{
			if (_respawnAt > -1 && diag_tickTime > _respawnAt) then
			{
				private _pos = [nil,["water"] /*+ any blacklisted locations*/] call BIS_fnc_randomPos;
				// TODO: Add remaing parameters here				
				private _newPatrol = [_pos] call GMSAI_fnc_spawnHelicoptorPatrol;
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
