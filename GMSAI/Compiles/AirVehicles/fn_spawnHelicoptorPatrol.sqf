/*
	GMS_fnc_spawnHelicopterPatrol 
	
	Purpose: spawn a helicopter patrol that will go from location to location on the map hunting for players 
			Locations: are any town, city etc defined at startup. 

	Parameters: 
		_pos, position to spawn chopper 
		_patrolArea - can be "Map" or "Region". "Region will respect the boundaries of a map marker while Map will patrol the entire map. 
		_blackListed - areas to avoid formated as [[x,y,z],radius]
		_center, center of the area, either mapCenter of center of the patrol area 
		_size, size of the area to be patroled, either mapSize or dimension of the patrol area 
		_shape, shap of the patrol area (rectangle by default)
		_timeout - how long to wait before deciding the chopper is 'stuck'

	Returns: [
		_group, the group spawned to man the heli 
		_heli, the chopper spawned selected by selectRandomWeighted GMSAI_aircraftTypes,  
	]

	Copywrite 2020 by Ghostrider-GRG- 

	Notes: 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp"
diag_log format["[GMSAI] _fnc_spawnMissionHeli: _this = %1",_this];
params[
		"_difficulty",
		"_aircraft",			// className of the aircraft to spawn
		"_pos",					// Random position for patrols that roam the whole map 
								// or center of the area to be patrolled for those that are restricted to a smaller region
		["_patrolArea","Map"],  // "Map" will direct the chopper to patrol the entire map, "Region", a smaller portion of the map.
		["_blackListed",[]],  	// areas to avoid within the patrol region
		["_timeout",300]];  	// The time that must elapse before the antistuck function takes over.]];
	
private _heli = createVehicle [
			_aircraft,
			_pos, 
			[], 
			0, 
			"FLY"
		];
_heli setFuel 1;
_heli engineOn true;
_heli flyInHeight 100;
_heli setVehicleLock "LOCKED";
[_heli] call GMS_fnc_emptyObjectInventory;
private _turrets = allTurrets [_heli,false];
private _maxGunners = GMSAI_aircraftGunners;
private _crewCount = if (count _turrets > _maxGunners) then {_maxGunners} else {count _turrets};
diag_log format["_fnc_spawnMissionHeli: count _turrets = %1 | _turrets = %2",count _turrets,_turrets];
private _difficulty = selectRandomWeighted GMSAI_aircraftPatrolDifficulty;

//params["_pos","_units",["_side",GMS_side],["_baseSkill",0.7],["_alertDistance",500],["_intelligence",0.5],["_monitor",false]];
private _group = [
	[0,0,0],
	_crewCount + 1,
	GMS_side,
	GMSAI_baseSkilByDifficulty select _difficulty,
	GMSA_alertDistanceByDifficulty select _difficulty,
	GMSAI_intelligencebyDifficulty select _difficulty,
	GMSAI_bodyDeleteTimer,
	GMSAI_maxReloadsInfantry,
	GMSAI_launcherCleanup,
	GMSAI_removeNVG,
	GMSAI_minDamageForSelfHeal,
	GMSAI_maxHeals,
	GMSAI_unitSmokeShell 
] call GMS_fnc_spawnInfantryGroup;

private _crew = units _group;
private _pilot = _crew deleteAt 0;
_pilot assignAsDriver _heli;
_pilot moveInDriver _heli;
_pilot  doMove (_pos getPos[3000,random(359)]); 
_group selectLeader _pilot;
diag_log format["_fnc_spawnMissionHeli: group %1 contains %2 crew | _pos = %3",_group, count _crew, _pos];

[_group,GMSAI_unitDifficulty select (_difficulty)] call GMS_fnc_setupGroupSkills;
[_group, GMSAI_unitLoadouts select _difficulty, 0 /* launchers per group */, GMSAI_useNVG, GMSAI_blacklistedGear] call GMS_fnc_setupGroupGear;
[_group,_difficulty,GMSAI_money] call GMS_fnc_setupGroupMoney;
//[_group,GMSAI_bodyDeleteTimer] call GMS_fnc_setGroupBodyDespawnTime;

//  TODO: build in additional check for blacklisted turrets.
private _gunnerCount = if (_maxGunners > count _turrets) then {count _turrets} else {_maxGunners};
{
	if !(_crew isEqualTo []) then
	{
		private _unit = _crew deleteAt 0;
		_unit assignAsTurret [_heli, _x];
		_unit moveInTurret [_heli, _x];
		diag_log format["_fnc_spawnMissionHeli: moving crew member %1 into turret %2 | _crew = %3",_unit,_x, _crew];
	};
} forEach _turrets;
// delete any excess crew not added to chopper 
{deleteVehicle _x} forEach _crew;

[_heli] call GMSAI_fnc_aircraftAddEventHandlers;

if (_patrolArea isEqualTo "Map") then 
{
	(_group) call GMSAI_fnc_initializeAircraftWaypoints;  // setup waypoint statements server side to avoid BE issues down the road.
} else {
	if (_center isEqualTo [0,0,0]) then {_center = _pos};
	[format["[]Patrol _center for Airpatrol group %1 was undefined and was set to %2",_group,_pos],"warning"] call GMSAI_fnc_log;
	// TODO: Revisit to update for area patrols
	// Leverage the ability of GMS to run ANY group's waypoints within an area proscribed by a local map marker
	/*
		params["_group",  // group for which to configure / initialize waypoints
				["_blackListed",[]],  // areas to avoid within the patrol region
				["_patrolAreaMarker",""],  // a marker defining the patrol area center, size and shape
				["_timeout",300]
			]; 
	*/
	[_group,_blacklisted,_patrolArea,_timeout] call GMS_fnc_initializeWaypointsAreaPatrol;
	// Note: the group is added to the list of groups monitored by GMS. Empty groups are deleted, 'stuck' groups are identified.
};
//  Need to add checks to to unlock vehicle if release to players is allowed.
private _return = [_group,_heli];
diag_log format["[GMSAI] _fnc_spawnMissionHeli: _return = %1",_return];
_return
