/*
	GMSAI_fnc_monitorParatroopSpawns 

	Purpose: monitor para groups to keep them hunting till nothing is left then despawn them.

	Parameters: None 

	Returns: None 

	Copyright 2020 Ghostrider-GRG-

	Notes: may not be used 

	TODO: check if this can be deleted
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
diag_log format["_fnc_monitorParatroopSpawns: called at %1",diag_tickTime];
{
	//  There are a lot of checks to do so break them down by most to least common where possible
	_x params["_group","_aircraft"];  //,"_spawned"];
	private _paraGroup = _group getVariable "GMSAI_paraGroup";
	private _inbound = _group getVariable "GMSAI_heliInbound";

	if (isNil "_inbound") then 
	{
		if !(isNil "_paraGroup") then // a group is already spawned for this patrol so do housekeeping
		{
			diag_log format["_monitorParatroopSpawn: _paraGroup = %1",_paraGroup];
			if (isNull _paraGroup) then // all units in the group are dead so reset things appropriately
			{
				_group setVariable["GMSAI_paraGroup",nil];
				GMSAI_paratroopGroupsSpawned = GMSAI_paratroopGroupsSpawned - 1;
			};
		} else {
			diag_log format["_monitorParatroopSpawns: _group %1 | _aircraft %2 | crew count = %3",_group,typeOf _aircraft, {alive _x}count (crew _aircraft)];
			if ( {alive _x} count (crew _aircraft) > 0 && !(isNull _aircraft)) then // Check that the air patrol group is active
			{
				diag_log format["_monitorParatroopSpawns: GMSAI_paratroopGroupsSpawned = %1 | _lastSpawned = %2 | _spawnAt = %3 | diag_tickTime %4",GMSAI_paratroopGroupsSpawned,_group getVariable ["GMSAI_lastParaSpawn",-1], (_group getVariable ["GMSAI_lastParaSpawn",-1]) + GMSAI_paratroopRespawnTimer, diag_tickTime];
				// allow checks for spawning new paratroops if max number of paratroop groups < max and this patrol has not spawned one within the time specified by the respawn timer.
				if (GMSAI_paratroopGroupsSpawned < GMSAI_maxParagroups && diag_tickTime > (_group getVariable ["GMSAI_lastParaSpawn",-1]) + GMSAI_paratroopRespawnTimer) then 
				{
					// Check for player enemies // strategies need work.
					private _target = _group getVariable["GMSAI_target",objNull];
	
					if (isNull _target) then
					{
						_target =  (leader _group) findNearestEnemy (position (_leader));
					};
					diag_log format["_monitorParatroopSpawns: _target = %1",_target];					
					if !(isNull _target) then // an enemy was found
					{
						if (random(1) < GMSAI_oddsParatroops) then // lets call in reinforcements
						{
							_target call GMSAI_fnc_flyInParatroopers;
							GMSAI_paratroopGroupsSpawned = GMSAI_paratroopGroupsSpawned + 1;
						};
					};
				};
			};
		};
	} else {
		diag_log format["_monitorParatroopSpawns: paragroup inbound so no action taken"];
	};
} forEach (GMSAI_airPatrols + GMSAI_UAVPatrols);

/*
CONFIGURATION and tracking VARIABLES
GMSAI_paratroopGroupsSpawned
----------------------------
GMSAI_maxParagroups = 5;  // maximum number of groups of paratroups spawned at one time.
GMSAI_oddsParatroops = 0.99999;
GMSAI_numberParatroops = [2,4]; // can be a single value (1, [1]) or a range
GMSAI_paratroopDifficulty = [GMSAI_difficultyBlue,0.40,GMSAI_difficultyRed,0.40,GMSAI_difficultyGreen,0.15,GMSAI_difficultyOrange,0.05];
GMSAI_paratroopRespawnTimer = 900;
GMSAI_paratroopAircraftTypes = [  // Note: this is a weighted array of vehicles used to carry paratroops in to locations spotted by UAVs or UGVs
	"B_Heli_Transport_01_F",5,
	"B_Heli_Light_01_F",1,
	"I_Heli_light_03_unarmed_F",5,
	"B_Heli_Transport_03_unarmed_green_F",5,
	"I_Heli_light_03_F",1,
	"O_Heli_Light_02_F",2,
	"B_Heli_Transport_03_unarmed_F",5
];
*/
/*			//  Do a check for spawning paratroops
			if (_aircraft getVariable ["paratroopsSpawnedTime",0] == 0 || ( _aircraft getVariable ["paratroopsSpawnedTime",0] != 0) && diag_tickTime > (_aircraft getVariable ["paratroopsSpawnedTime",0]) + GMSAI_paratroopRespawnTimer) then
			{
				private _nearestEnemy =  (leader _crewGroup) findNearestEnemy (position (leader _crewGroup));
				if !(isNull _nearestEnemy) then
				{
					if (random(1) < GMSAI_aircraftChanceOfParatroops) then
					{
						[_aircraft] call GMSAI_fnc_spawnParatroops;
					};
					_crewGroup setVariable["paratroopsSpawnedTime",diag_tickTime];  //  reset timer whether or not paratroops were spawned.
				};
			};
*/

/*

	LOGIC 

	1. two cases to consider: possibly treat them as one: helicopter on patrol that could spawn paras; UAV which should not.
	- Treat these the same -> call _flyInParatroops;
	2. General conditiosn for spawn/no spawn checks:
	- no paratroops linked to that vehicle 
	- time since last para spawn > respawn timer.
	3. Detection logic: when to call in paratroops: 
	- group has 'target' or not.
	- random(1) < odds for paras for that aircraft patrool type
	- enemy detected by: search for nearby players; aircraft hit detection; crew hit detection; crew killed detection; 
	  Note that chance of enemy being 'seen' increases with each hit or kill so checking those may be redundant.
    - checking this every 5-10 secs should be enough
