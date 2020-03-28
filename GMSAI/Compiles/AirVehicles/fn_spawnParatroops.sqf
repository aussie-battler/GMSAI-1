/*
	Check whether conditions for spawning reinforcements are met and if so call them in. 

*/

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

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_crewGroup","_aircraft"];
// Basic conditions for spawns must be met
if (count GMSAI_paratroopGroups > GMSAI_maxParagroups) exitWith {["spawnParatroops: maximum number of active reinforments reached"] call GMSAI_fnc_log};
private _respawnAt = _crewGroup getVariable "respawnParaDropAt";
if (isNil "_respawnAt") then {_crewGroup setVariable["respawnParaDropAt", diag_tickTime + [GMSAI_aircraftRespawnTime] call GMS_fnc_selectNumberFromRange]};
if (diag_tickTime < _respawnAt) exitWith {[format["spawnParatroops: group %1 still cooling down with respawnAt = %2 with current time = %3",_crewGroup,_respawnAt,diag_tickTime]] call GMSAI_fnc_log;};
if ( (random(1) < GMSAI_chanceParatroopsSpawn) && (random(1) < GMSAI_chancePlayerDetected)) exitWith {["spawnParatroops: test for chance of spawn failed: the player lucked out!"] call GMSAI_fnc_log};
private _pilot = driver _aircraft;
private _target = _pilot findNearestEnemy _pilot;
if (isNull _target) then // no known enemies nearby 
{
	// this is just a test of whether knowsAbout reflects info about whether a player is an enemy 
	{
		if ((_pilot knowsAbout _x) > 0.1) exitWith 
		{
			_target = _x;
			[format["dropParatroops: _pilot knowsAbout %1 = %2",_x, _pilot knowsAbout _x]] call GMSAI_fnc_log;
		};
	} forEach allPlayers;
};
if (isNull _target) exitWith 
{  // test if any players can be seen by any of the aircraft crew and if so bump their knowsAbout value
	private _nearPlayers = allPlayers select {(_aircraft distance _x) < 300};
	{
		private _p = _x;
		{
			if ([_x,_p] call GMS_fnc_unitCanSee) then 
			{
				_x reveal[_p,0.25];
			};
		} forEach (crew _aircraft);
	} forEach allPlayers select {(_aircraft distance _x) < 300};
	[format["spawnParatroops: group %1 updated on visible players at %2",_crewGroup,diag_tickTime]] call GMSAI_fnc_log;
};
if (typeOf _aircraft in GMSAI_aircraftTypes) exitWith // we can use that aircraft to drop some AI 
{
	_crewGroup setSpeedMode "LIMITED";
	uiSleep [[3,6] call GMS_fnc_selectNumberFromRange];
	// This gives the illusion of the chopper slowing and hunting
	private _paraGroup = [_crewGroup,_aircraft,_target] call GMSAI_fnc_dropReinforcements;	
	GMSAI_paratroopGroups pushBack _paraGroup;
	_crewGroup setVariable ["respawnParaDropAt", diag_tickTime + [GMSAI_aircraftRespawnTime] call GMS_fnc_selectNumberFromRange];
	[[format["monitorAirPatrols: reinforcements dropped by %1 at %2",_crewGroup, diag_tickTime]]] call GMSAI_fnc_log;
	uiSleep 2;
	_crewGroup setSpeedMode "NORMAL";
};
if ((typeOf _aircraft) in GMSAI_UAVTypes) then 
{
	private _paraGroup = [getPosATL _aircraft,_crewGroup,_target] call GMSAI_fnc_flyInReinforcements; 
	GMSAI_paratroopGroups pushBack _paraGroup;
	_crewGroup setVariable ["respawnParaDropAt", diag_tickTime + [GMSAI_aircraftRespawnTime] call GMS_fnc_selectNumberFromRange];	
	[[format["monitorAirPatrols: UAV has called in reinforcements at %1",diag_tickTime]]] call GMSAI_fnc_log;	
};

