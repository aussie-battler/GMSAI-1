/*
	GMS_fnc_spawnVehiclePatrol 
	Purpose: spawn a vehicle patrol that will go from location to location on the map or patrols a proscribed area hunting for players 
	when '_isSubmersible == true the script will assume it should set swimInDepth as well
	Locations: are any town, city etc defined at startup. 
	Copywrite 2020 by Ghostrider-GRG- 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp"
params[
		"_pos",				// Random position for patrols that roam the whole map 
								// or center of the area to be patrolled for those that are restricted to a smaller region
		["_patrolType","Map"],  // "Map" will direct the vehicle to patrol the entire map, "Region", a smaller portion of the map.
		["_blackListed",[]],  // areas to avoid within the patrol region
							 // These parameters are ignored if the vehicle will patrol the entire map.
		["_center",[0,0,0]],  // center of the area to be patroled
		["_size",[200,200]],  // size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
		["_timeout",300],		// The time that must elapse before the antistuck function takes over.]];
		["_isSubmersible",false]
	];  

private _vehicle = createVehicle [selectRandomWeighted GMSAI_patrolVehicles, _pos, [], 10, "NONE"];
[_vehicle] call GMS_fnc_emptyObjectInventory;
private _crewCount = [GMSAI_patroVehicleCrewCount] call GMS_fnc_getIntegerFromRange;
private _difficulty = selectRandomWeighted GMSAI_vehiclePatroDifficulty;
private _group = [
	[0,0,0],
	[_crewCount] call GMS_fnc_getIntegerFromRange,
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
diag_log format["GMSAI_fnc_spawnVehiclePatrol: _group = %1",_group];
//uisleep 1;
[_vehicle,units _group] call GMS_fnc_loadVehicleCrew;
[_group,GMSAI_unitDifficulty select _difficulty] call GMS_fnc_setupGroupSkills;
[_group, GMSAI_unitLoadouts select _difficulty, 0 /* launchers per group */, GMSAI_useNVG, GMSAI_blacklistedGear] call GMS_fnc_setupGroupGear;
[_group,_difficulty,GMSAI_money] call GMS_fnc_setupGroupMoney;

_vehicle addMPEventHandler["MPHit",{if (isServer) then {_this call GMSAI_fnc_processVehicleHit}}];
_vehicle addMPEventHandler["MPKilled",{if (isServer) then {_this call GMSAI_fnc_processVehicleKilled}}];
_vehicle addEventHandler["HandleDamage",{if (isServer) then {_this call GMSAI_fnc_vehicleHandleDamage}}];
{
	_x addMPEventHandler ["MPKilled", {if (isServer) then {_this call GMSAI_fnc_processVehicleCrewKilled}}];
	_x addMPEventHandler ["MPHit", {if (isServer) then {_this call GMSAI_fnc_processVehicleCrewHit;}}];
	_x addEventHandler["HandleDamage",{if (isServer) then {_this call GMSAI_fnc_vehicleCrewHandleDamage}}];
	_x addEventHandler ["GetOut",{_this call GMSAI_fnc_processVehicleCcrewGetOut;}];
} forEach (crew _vehicle);

if (_isSubmersible) then 
{
	// set the swimindept to 1/2 the height of surface level above ground leve of the driver of the vehicle
	_driver swimInDepth (((getPosATL(ASLtoATL(getPosASL(driver _vehicle))) ) select 2)/2);
};
if (_patrolType isEqualTo "Map") then 
{
	(driver _vehicle) call GMSAI_fnc_initializeVehicleWaypoints;
} else {
		/*
		params["_group",  // group for which to configure / initialize waypoints
		["_blackListed",[]],  // areas to avoid within the patrol region
		["_center",[0,0,0]],  // center of the area to be patroled
		["_size",[200,200]],  // size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
		["_timeout",300]];  // The time that must elapse before the antistuck function takes over.
	*/
	#define addGrouptoMonitoredGroups true
	if (_center isEqualTo [0,0,0]) then {_center - _pos};
	[format["[]Patrol _center for vehicle group %1 was undefined and was set to %2",_group,_pos],"warning"] call GMSAI_fnc_log;
	// TODO: Revisit to update for area patrols
	[_group,_blacklisted,_center,_size,_shape,_timeout] call GMS_fnc_initializeWaypoints;
	// Note: the group is added to the list of groups monitored by GMS. Empty groups are deleted, 'stuck' groups are identified.
};

private _return = [_group,_vehicle];
_return
