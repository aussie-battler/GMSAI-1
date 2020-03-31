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
		private _group = _player getVariable "GMSAI_Group";
		if !(isNil "_group") then // a group was spawned so lets evaluate it.
		{
			diag_log format["_dynamicAIManger: evaluating active group %1 for player %2 with group on side %3 and leader of the group on side %4",_group,_player,side _group, side (leader _group)];
			if (_group isEqualTo grpNull || {alive _x} count (units _group) == 0) then  
			{
				_player setVariable["group",nil];
				_player setVariable["respawnAt",(diag_tickTime + GMSAI_dynamicRespawnTime)];
				deleteMarker (_player getVariable["GMSAI_patrolAreaMarker",""]);
				if (GMSAI_debug >= 1) then {deleteMarker (_player getVariable["GMSAI_debugMarker",""])};;
			} else {
				_lastChecked = _group getVariable "lastChecked";
				if (isNil ("_lastChecked")) then
				{
					_group setVariable ["lastChecked",diag_tickTime];
				} else {
					private _players = allPlayers inAreaArray [getPos (leader _group),GMSAI_dynamicDespawnDistance,GMSAI_dynamicDespawnDistance];
					diag_log format["_dynamicAIManger: _players = %1 | _lastChecked = %2",_players,_lastChecked];
					if (_players isEqualTo []) then
					{
						diag_log format["_dynamicAIManger: current  time = %3 | _lastChecked = %1, delete at %2",_lastChecked,_lastChecked + GMSAI_dynamicDespawnTime, diag_tickTime];
						if (diag_tickTime > (_lastChecked + GMSAI_dynamicDespawnTime)) then
						{
							[_group] call GMS_fnc_despawnInfantryGroup;
							_player setVariable["group",nil];
							_player setVariable["respawnAt",(diag_tickTime + GMSAI_dynamicRespawnTime)];
							deleteMarker (_player getVariable["GMSAI_debugMarker",""]);	
							deleteMarker (_player getVariable ["GMSAI_patrolAreaMarker",""]);
						};
					} else {
						_group setVariable ["lastChecked",diag_tickTime];
						if (GMSAI_debug >= 1) then {[_group] call GMSAI_fnc_updateGroupDebugMarker};
					};
				};
			};
		} else {  
			// no dynamic AI group has been spawned, lets check if one should be
			private _respawns = _player getVariable "respawns";
			if (isNil "_respawns") then
			{
				_respawns = 0;
				_player setVariable ["respawns",0];
			};	
			private _respawnsAllowed = _player getVariable "GMSAI_maximumRespawns";
			if (isNil "_respawnsAllowed") then
			{
				_respawnsAllowed = GMSAI_maximumDynamicRespawns;
				_player setVariable["maximumRespawns",_respawnsAllowed];
			};
			[format["_dynamicAIManger: no active dynamic group found for player %1, evaluating spawn parameters: _respawns = %2 | _respawnsAllowed = %3",_player,_respawns,_respawnsAllowed],"information"] call GMSAI_fnc_log;			
			if (_respawnsAllowed isEqualTo -1 || _respawns <= _respawnsAllowed) then
			{
				private _lastSpawnedAt = _player getVariable["lastSpawnedAt",0];
				private _respawnAt = _player getVariable "respawnAt";
				if (isNil "_respawnAt") then 
				{
					_player setVariable["respawnAt",(diag_tickTime + GMSAI_dynamicRespawnTime)];
					_respawnAt = _player getVariable "respawnAt";
				};
				diag_log format["[GMSAI] _dynamicAIManger: _respawnAt = %1 | current time %2 | GMSAI_dynamicRespawnTime = %3",_respawnAt,diag_tickTime,GMSAI_dynamicRespawnTime];		
				if (diag_tickTime >_respawnAt && (vehicle _player == _player)) then
				{
					diag_log format["[GMSAI] _dynamicAIManger: spawn condition reached"];
					if (random(1) < GMSAI_dynamicRandomChance) then
					{
						private _dynamicAI = _player nearEntities["I_G_Sharpshooter_F",300];
						[format["_dynamicAIManger: evaluating nearby units:  _dynamicAI = %1",_dynamicAI],"information"] call GMSAI_fnc_log;
						if (_dynamicAI isEqualTo []) then  
						//  Only spawn dynamic AI if there are no other roamers around. -- May want to rethink this
						{	// TODO: add loop to spawn groups accordiing to number set in GMSAI_dynamicRandomGroups
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

							/*
								params[
										"_difficulty",
										"_spawnPos", // center of the patrol area
										"_units",  // units to spawn, can be integer, [1], or range [2,3]
										["_patrolAreaMarker",""]
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
							_player setVariable["GMSAI_Group",_group];

							if (GMSAI_debug >= 1) then {[_group] call GMSAI_fnc_addGroupDebugMarker};		
							
							_group setVariable["despawnDistance",GMSAI_dynamicDespawnDistance];
							_group setVariable["despawnTime",GMSAI_dynamicDespawnTime];	
							_group reveal[_player,0.1];		

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
							_player setVariable["group",_group,true];
							_player setVariable["patrolAreaMarker",_dynamicPatrolMarker,true];
							if (GMSAI_debug >= 1) then {_player setVariable["GMSAI_groupDebugMarker",[_group] call GMSAI_fnc_getGroupDebugMarker]};
							["notification",format["The target is %1 - seek and destroy",name _player]] call GMS_fnc_messagePlayers;
						};
					} else {
						_player setVariable["GMSAI_dynamicRespawnAt",diag_tickTime + (GMSAI_dynamicDespawnTime/2)];
					};	
				};
			};
		};
	} forEach allPlayers;
};
