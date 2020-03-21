/*
	GMS_fnc_spawnHelicopterPatrol 
	Purpose: spawn a helicopter patrol that will go from location to location on the map hunting for players 
	Locations: are any town, city etc defined at startup. 
	Copywrite 2020 by Ghostrider-GRG- 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp"
diag_log format["[GMSAI] _fnc_spawnMissionHeli: _this = %1",_this];
params["_pos",					// Random position for patrols that roam the whole map 
								// or center of the area to be patrolled for those that are restricted to a smaller region
		["_patrolType","Map"],  // "Map" will direct the chopper to patrol the entire map, "Region", a smaller portion of the map.
		["_blackListed",[]],  // areas to avoid within the patrol region
							 // These parameters are ignored if the chopper will patrol the entire map.
		["_center",[0,0,0]],  // center of the area to be patroled
		["_size",[200,200]],  // size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
		["_timeout",300]];  // The time that must elapse before the antistuck function takes over.]];

	
private _heli = createVehicle [
	selectRandomWeighted GMSAI_aircraftTypes, 
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
	false
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
[_group,GMSAI_aircraftDesapwnTime] call GMS_fnc_setGroupBodyDespawnTime;

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

_heli addMPEventHandler["MPHit",{_this call GMSAI_fnc_processAircraftHit}];
_heli addMPEventHandler["MPKilled",{_this call GMSAI_fnc_processVehicleKilled}];
_heli addEventHandler["HandleDamage",{_this call GMSAI_fnc_vehicleHandleDamage}];
{
	_x addMPEventHandler ["MPKilled", {_this call GMSAI_fnc_processAircraftCrewKilledi;}];
	_x addMPEventHandler ["MPHit", {_this call GMSAI_fnc_processAircraftCrewHit;}];
	_x addEventHandler ["GetOut",{_this call GMSAI_fnc_processVehicleCrewGetOut;}]	
} forEach (crew _heli);

if (_patrolType isEqualTo "Map") then 
{
	(_group) call GMSAI_fnc_initializeAircraftWaypoints;  // setup waypoint statements server side to avoid BE issues down the road.
} else {
		/*
		params["_group",  // group for which to configure / initialize waypoints
		["_blackListed",[]],  // areas to avoid within the patrol region
		["_center",[0,0,0]],  // center of the area to be patroled
		["_size",[200,200]],  // size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
		["_timeout",300]];  // The time that must elapse before the antistuck function takes over.
	*/
	if (_center isEqualTo [0,0,0]) then {_center - _pos};
	[format["[]Patrol _center for Aircraft group %1 was undefined and was set to %2",_group,_pos],"warning"] call GMSAI_fnc_log;	
	[_group,_blacklisted,_center,_size,_shape,_timeout] call GMS_fnc_initializeWaypoints;
	// TODO: add group to list of groups monitored by GMS: need a function to do this, or a parameter for inializeWaypoints
};
//  Need to add checks to to unlock vehicle if release to players is allowed.
private _return = [_group,_heli];
diag_log format["[GMSAI] _fnc_spawnMissionHeli: _return = %1",_return];
_return
