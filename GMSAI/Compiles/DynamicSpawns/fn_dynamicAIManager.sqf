/*
	GMSAI_fnc_dynamicAIManager 

	Purpose: handles spawning, monitoring and despawning of dynamic AI. 
			These spawn with the intent of hunting a specific player but can hunt others in the area if that player is gone. 

	Parameters: None 

	Returns: None 

	Copyright 2020 Ghostrider-GRG-

	Notes: checks if other AI units are nearby and cools down if so to avoid having dynamics spawned in an area for more than one player.

*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
#define GMSAI_dynamicSpawnDistance 300
#define GMSAI_dynamicDespawnDistance 400
#define GMSAI_alertAIDistance 300

diag_log format["[GMSAI] running DYNAMIC AI MONITOR at %1 | count allPlayer = %2 | GMSAI_useDynamicSpawns = %4 | GMSAI_maximumDynamicRespawns = %3",diag_tickTime, count allPlayers, GMSAI_maximumDynamicRespawns,GMSAI_useDynamicSpawns];
if (GMSAI_useDynamicSpawns) then
{

	{
		private _player = _x;	
		private _group = _player getVariable "group";

		/*
			HANDLE DESPAWNING HERE
		*/
		if !(isNil "_group") then 
		{
			// a group was spawned so lets evaluate it.
			// Do not fiddle with lastChecked which is used by GMS and should be invisible
			/*
				Steps 
				1. (group isEqualTo grpNull || all units in group are dead): set the "group" variable on player to nil, 
					-> set value on player for 'respawnAt"
					
				2. group exists and has units but the original player is not in the area. 
					2.a the player has left the area, no other playres are in range, and diag_tickTime > lastChecked + despawnTime 
						-> delete the group, set player variable for respawnAt, cleanup group markers 

					2.b the player has left th earea, no other players are in range and diag_tickTime < lastChecke + despawnTime 
						Do nothing, do NOT change lastChecked, use this as a surrogate for playerLastSeen 
					2.c the player left the area, other players are in the area 
						update waypoints 

				3. The player is in the area 
					- > update waypoints and lastSeen
			*/			
			diag_log format["_dynamicAIManger: evaluating active group %1 for player %2 with group on side %3 and leader of the group on side %4",_group,_player,side _group, side (leader _group)];

			// Step 1.
			if (_group isEqualTo grpNull || {alive _x} count (units _group) == 0) then  
			{
				[format["_dynamicAImonitor:  processing empty or null group: _group = %1",_group]] call GMSAI_fnc_log;
				if !(isNull _group) then {deleteGroup _group};
				_player setVariable["group",nil];
				_player setVariable["respawnAt",(diag_tickTime + GMSAI_dynamicRespawnTime)];
				_patrolMarker = _player getVariable["patrolAreaMarker",""];
				[format["_dynamicAIMonitor: cleaning up empty or null group | _player = %1 } _group = %2 | _patrolMarker = %3",_player,_group,_patrolMarker]] call GMSAI_fnc_log;

				if (GMSAI_debug >= 1) then {
					deleteMarker (_player getVariable["GMSAI_debugMarker",""]);
					deleteMarker _patrolMaker;	
				} else {
					deleteMarkerLocal _patrolMarker;
				};
			} else {
				// Step 3. Player is in the area 
				private _playersInArea = [_player] inAreaArray [getPos (leader _group),GMSAI_dynamicDespawnDistance,GMSAI_dynamicDespawnDistance];
				[format["_dynamicAImonitor: _playersInArea = %1",_playersInArea]] call GMSAI_fnc_log;
				if !(_playersInArea isEqualTo []) then 
				{
					[format["_dynamicAImonitor: _player %1 still in patrol area",_player]] call GMSAI_fnc_log;
					(leader _group) call GMS_fnc_nextWaypointAreaPatrol;
				} else {
					// Step 2.  The group is alive but the player has left - lets see if other players are around do some housekeeping and update its information and waypoints as necessary	
					private _playerLastSeen = _group getVariable "lastSeen";
					if (isNil "_playerLastSeen") then 
					{
						_playerLastSeen = diag_tickTime;
						_group setVariable ["lastSeen",_playerLastSeen];
					};
					[format["_dynamicAIManager: _playerLastSeen = %1 | diagTickTime = %2",_playerLastSeen,diag_tickTime]] call GMSAI_fnc_log;
					
					// Step 2.a 	
					private _players = (allPlayers select {alive _x}) inAreaArray [getPos (leader _group),GMSAI_dynamicDespawnDistance,GMSAI_dynamicDespawnDistance];	
					[format["_dynamicAImonitor: player left area, _players = %1 | _playerLastSeen = %2 | time = %3",_player,_playerLastSeen,diag_tickTime]] call GMSAI_fnc_log;
					if (_players isEqualTo []) then 
					{				
						[format["_dynamicAImonitor: no alive players in area patroled by group %1",_group]] call GMSAI_fnc_log;
						if (diag_tickTime >= _playerLastSeen + GMSAI_dynamicDespawnTime) then 
						{
							private _patrolMarker = _player getVariable["patrolAreaMarker",""];
							[format["_dynamicAImonitor:  (90)  _patrolMarker = %1",_patrolMarker]]  call GMSAI_fnc_log;

							[format["_dynamicAIManager: group alive&& no player near -> desapwn condition reached: deleting AI _patrolMarker = %1 for group %2",_patrolMarker,_group]] call GMSAI_fnc_log;
							if (GMSAI_debug >= 1) then 
							{
								deleteMarker (_player getVariable["GMSAI_debugMarker",""]);
								deleteMarker _patrolMarker;
							} else {
								deleteMarkerLocal _patrolMarker;
							};
							[_group] call GMS_fnc_despawnInfantryGroup;
							_player setVariable["respawnAt", diag_tickTime + GMSAI_dynamicRespawnTime];
						} else {
							// Step 2.b. 
							(leader _group) call GMS_fnc_nextWaypointAreaPatrol;
						};
					
					} else {
						// Step 2.c   
						_group setVariable ["lastSeen",diag_tickTime];
						(leader _group) call GMS_fnc_nextWaypointAreaPatrol;

					};
				};
			};
		} else {  

			/*
				HANDLE SPAWNING HERE
			*/
			// _group was nil when we checked so no dynamic AI group has been spawned, lets check if one should be
			/*
				Steps: 
				
				1. The player must be initialized with certain information 
					respawnAt (initialized if nil to diag_tickTime)
					respawns (initialized if nil to 0)

				2. The following checks have to be passed for spawn to occur 
					a. _respawns < GMSAI_maximumDynamicRespawns || GMSAI_maximumDynamicRespawns == -1;
						AND (vehicle _player isEqualTo _player)
					b. random(1) < GMSAI_dynamicRandomChance
					c. diag_tickTime >_respawnAt && (vehicle _player == _player)  
						-> where _respawnAt is initialized at GMSAI_dynamicRespawnTime
					d. no other GMSAI units nearby (so we dont oversaturate an area)

				3. once a group is spawn, group and player need certain variables set.
					3.a Define a patrol area marker 
					3.b Spawn in a group 
					3.c configure the group
					3.d Initialze Group Variables: The group spawned must be initialize with certain information: 
						patrolAreaMarker 
						groupDebugMarker (if used) 
						_player 
					3.e Save the group and marker info for monitoring.

					3.f Player initialization: the player must be initialized with some information about the group spawned.
						patrolAreaMarker 
						groupDebugMarker (if used) 
						_group
						reveal player to group
			*/

			// Player Initialization 1.a
			private _respawnAt = _player getVariable "respawnAt";
			if (isNil "_respawnAt") then 
			{
				_player setVariable["respawnAt",(diag_tickTime + GMSAI_dynamicRespawnTime)];
				_respawnAt = _player getVariable "respawnAt";
			};

			// Player initialization 1.b
			private _respawns = _player getVariable "respawns";
			if (isNil "_respawns") then 
			{
				_respawns = 0;
				_player setVariable["respawns",_respawns];
			};

			[format["_dynamicAIManger: no active dynamic group found for player %1, evaluating spawn parameters: _respawns = %2 | _respawnAt = %3",_player,_respawns,_respawnAt],"information"] call GMSAI_fnc_log;	

			// Check 2.a 		
			if (GMSAI_maximumDynamicRespawns == -1 || _respawns <= GMSAI_maximumDynamicRespawns) then
			{
				diag_log format["[GMSAI] _dynamicAIManger: _respawnAt = %1 | current time %2 | GMSAI_dynamicRespawnTime = %3",_respawnAt,diag_tickTime,GMSAI_dynamicRespawnTime];	

				// Check 2.b 	
				if (diag_tickTime >_respawnAt && (vehicle _player == _player)) then
				{
					diag_log format["[GMSAI] _dynamicAIManger: spawn condition reached"];

					// Check 2.c
					if (random(1) < GMSAI_dynamicRandomChance) then
					{
						// Check 2.d
						private _dynamicAI = _player nearEntities["I_G_Sharpshooter_F",300];
						[format["_dynamicAIManger: evaluating nearby units:  _dynamicAI = %1",_dynamicAI],"information"] call GMSAI_fnc_log;
						if (_dynamicAI isEqualTo []) then  
						{	// TODO: add loop to spawn groups accordiing to number set in GMSAI_dynamicRandomGroups

							// START STEP 3 - SPAWNING THE GROUP

							// Step 3.a define an area patrol marker deliniating the operating area for the group
							private _spawnPos = (getPosATL _player) getPos[GMSAI_dynamicSpawnDistance,random(359)];	
							[format["_dynamicAIManger: _spawnPos = %1",_spawnPos],"information"] call GMSAI_fnc_log;
							private _dynamicPatrolMarker = "";
							if (GMSAI_debug >= 1) then 
							{										
								_dynamicPatrolMarker = createMarker[format["GMSAI_dynamic%1",diag_tickTime],_spawnPos];
								_dynamicPatrolMarker setMarkerShape "RECTANGLE";
								_dynamicPatrolMarker setMarkerSize [GMSAI_dynamicSpawnDistance + 100,GMSAI_dynamicSpawnDistance + 100];
								_dynamicPatrolMarker setMarkerColor "COLORBLACK";
								_dynamicPatrolMarker setMarkerAlpha 0.4;
							} else {
								_dynamicPatrolMarker = createMarkerLocal[format["GMSAI_dynamic%1",diag_tickTime],_spawnPos];
								_dynamicPatrolMarker setMarkerShapeLocal "RECTANGLE";
								_dynamicPatrolMarker setMarkerSizeLocal [GMSAI_dynamicSpawnDistance + 100,GMSAI_dynamicSpawnDistance + 100];
							};
							[format["_dynamicAIManger: _dynamicPatrolMarker = %1 | typeName _dynamicPatrolMarker = %2",_dynamicPatrolMarker,typeName _dynamicPatrolMarker],"information"] call GMSAI_fnc_log;

							// Steps 3.b and 3.c since GMSAI_fnc_spawnInfantryGroup will configure skills, gear, based on loot tables for that difficulty.
							/*
								params[
										"_difficulty",
										"_spawnPos", // center of the patrol area
										"_units",  // units to spawn, can be integer, [1], or range [2,3]
										"_patrolMarker"
									];
							*/	
							private _difficulty = selectRandomWeighted GMSAI_dynamicUnitsDifficulty;
							private _units = [GMSAI_dynamicRandomUnits] call GMS_fnc_getIntegerFromRange;			
							private _group = [
								_difficulty,
								_spawnPos,
								_units,
								_dynamicPatrolMarker
							] call GMSAI_fnc_spawnInfantryGroup;

							[format["_dynamicAIManager: _group Spawned = %1",_group],"information"] call GMSAI_fnc_log;

							// Step 3.d Initialize variables on _group, such as debug markers and store group info
							_group setVariable["patrolAreaMarker",_dynamicPatrolMarker];
							_group setVariable["player",_player];
							if (GMSAI_debug >= 1) then {[_group] call GMSAI_fnc_addGroupDebugMarker};

							// Step 3.e Place information about the group and its patrol marker in an array we can monitor it with should be be uncoupled from the player, e.g. if the player dies.
							GMSAI_dynamicGroups pushBack [_group,_dynamicPatrolMarker];

							// Step 3.f Initialize variables on _player and reveal player to group
							_player setVariable["patrolAreaMarker",_dynamicPatrolMarker];
							_player setVariable["group",_group];
							_group reveal[_player,0.1];		

							// Step 3.g set group up to hunt targeted player
							#define GMSAI_waypointTimeout 60
							[
								/*
									params["_group",  // group for which to configure / initialize waypoints
											["_blackListed",[]],  // areas to avoid within the patrol region
											["_dynamicPatrolMarker",""],  // a marker defining the patrol area center, size and shape
											["_timeout",300]
										]; 
								*/
								_group,
								GMSAI_blackListedAreas,
								_dynamicPatrolMarker,
								GMSAI_waypointTimeout  //  Time in seconds within which the waypoint should be completed
							] call GMS_fnc_initializeWaypointsAreaPatrol;	
							[_group,_player] call GMS_fnc_assignTargetAreaPatrol;

							["notification",format["The target is %1 - seek and destroy",name _player]] call GMS_fnc_messagePlayers;
						};
					} else {
						_player setVariable["respawnAt",diag_tickTime + (GMSAI_dynamicDespawnTime/2)];
					};	
				};
			};
		};
	} forEach allPlayers;


	// Cleanup any markers for groups no longer linked to players and manage these groups until either there are no players in the area or the units of the group are dead or the group == null.
	/*
		Steps:
		1. If the _group == grpNull then delete the marker, dont add the descriptor back the the cue.
		2. If If the {alive _x} count (units _group) == 0 then delete marker, donet add descriptor back to cue 
		3. If player dead, search for new player targets within the area 
		`	3.a If none found and diag_tickTime > deleteAt then delete the group, delete the marker 
			3.b If one or more found, or none found and diag_tickTimc < deleteAt then call next Waypoint, add back to cue. 
		4. if _player alive, do nothing other than add descriptor back to the cue
	*/
	for "_i" from 1 to (count GMSAI_dynamicGroups) do
	{
		if (_i > (count GMSAI_dynamicGroups)) exitWith {};
		private _g = GMSAI_dynamicGroups deleteAt 0;
		_g params["_group","_marker"];

		
		// Step 1
		if (_group isEqualTo grpNull) then
		{
			if (GMSAI_debug >= 1) then 
			{
				deleteMarker _marker;
			} else {
				deleteMarkerLocal _marker;
			};
		} else {
			private _player = _group getVariable["player",objNull];
			// Step 4. just keep monitoring
			if (alive _player) then 
			{
				GMSAI_dynamicGroups pushBack _g;
			} else {
				// Step 2. delete empty groups and their marker
				if ({alive _x} count (units _group) == 0) then
				{
					[format["_dynamicAImanager:  _dynamicGroups monitor: empty group unlinked from player found, deleting it ant its marker: _group = %1 | _marker = %2",_group,_marker]] call GMSAI_fnc_log;
					[_group] call GMS_fnc_despawnInfantryGroup;
					if (GMSAI_debug >= 1) then 
					{
						deleteMarker _marker;
					} else {
						deleteMarkerLocal _marker;
					};
				} else {
					// Step 3. ;	Original Player dead - look for nearby players / test for deletaAt conditions				
					// test for players within 300 meters of the group leader 
					private _nearPlayers = allPlayers inAreaArray [getPos (leader _group),_group getVariable["despawnDistance",300],_group getVariable["despawnDistance",300]];
					if (_nearPlayers isEqualTo []) then
					{
						private _deleteAt = (_group getVariable["lastChecked",0]) + GMSAI_dynamicDespawnTime;
							// Step 3.a 
							if (diag_tickTime > _deleteAt) then 
							{
								[format["_dynamicAImanager: dynamic groups monitor: group alive no players near despawn conditions reached. deleting group %1 and its marker %2",_group,_marker]] call GMSAI_fnc_log;
								[_group] call GMS_fnc_despawnInfantryGroup;
								if (GMSAI_debug >= 1) then 
								{
									deleteMarker _marker;
								} else {
									deleteMarkerLocal _marker;
								};
							};
					// Step 3.b
					} else {
						GMSAI_dynamicGroups pushBack _g;
					};
				};	
			};																								
		};
	};

};


