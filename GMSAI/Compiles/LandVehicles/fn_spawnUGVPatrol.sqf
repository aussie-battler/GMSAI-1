/*
	GMS_fnc_spawnUGVePatrol 
	Purpose: spawn a UGV patrol that will go from location to location on the map hunting for players 
	Locations: are any town, city etc defined at startup. 
	Copywrite 2020 by Ghostrider-GRG- 
*/
#include "\addons\GMSAI\init\GMSAI_defines.hpp"
params["_pos",					// Random position for patrols that roam the whole map 
								// or center of the area to be patrolled for those that are restricted to a smaller region
		["_patrolType","Map"],  // "Map" will direct the chopper to patrol the entire map, "Region", a smaller portion of the map.
		["_blackListed",[]],  	// areas to avoid within the patrol region
							 	// These parameters are ignored if the chopper will patrol the entire map.
		["_center",[0,0,0]],  	// center of the area to be patroled
		["_size",[200,200]],  	// size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
		["_timeout",300]];  	// The time that must elapse before the antistuck function takes over.]];

private _ugv = createVehicle [selectRandomWeighted GMSAI_UGVtypes, _pos, [], 10, "NONE"];
_ugv setFuel 1;
_ugv engineOn true;
_ugv setVehicleLock "LOCKED";
[_ugv] call GMS_fnc_emptyObjectInventory;
private _group = _ugv call GMS_fnc_createUnmanedVehicleCrew;  // Make sure the vehicle faction is the same as the GMS_side faction
private _difficulty = selectRandomWeighted GMSAI_UGVdifficulty;
[_group,GMSAI_unitDifficulty select _difficulty] call GMS_fnc_setupGroupSkills;

_ugv addMPEventHandler["MPHit",{if (isServer) then {_this call GMSAI_fnc_processVehicleHit}}];
_ugv addMPEventHandler["MPKilled",{if (isServer) then {_this call GMSAI_fnc_processVehicleKilled}}];
_ugv addEventHandler["HandleDamage",{if (isServer) then {_this call GMSAI_fnc_vehicleHandleDamage}}];
{
	_x addMPEventHandler ["MPKilled", {if (isServer) then {_this call GMSAI_fnc_processVehicleCrewKilled}}];
	_x addMPEventHandler ["MPHit", {if (isServer) then {_this call GMSAI_fnc_processVehicleCrewHit;}}];
	_x addEventHandler["HandleDamage",{if (isServer) then {_this call GMSAI_fnc_vehicleCrewHandleDamage}}];
	_x addEventHandler ["GetOut",{_this call GMSAI_fnc_processVehicleCcrewGetOut;}];
} forEach (crew _ugv);

if (_patrolType isEqualTo "Map") then 
{
	(driver _ugv) call GMSAI_fnc_initializeVehicleWaypoints;
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
	[format["[]Patrol _center for UGV group %1 was undefined and was set to %2",_group,_pos],"warning"] call GMSAI_fnc_log;	
	// TODO: Revisit this to configure for area patrols
	[_group,_blacklisted,_center,_size,_shape_timeout] call GMS_fnc_initializeWaypoints;
	// Note: the group is added to the list of groups monitored by GMS. Empty groups are deleted, 'stuck' groups are identified.
};

private _return = [_group,_ugv];
_return
