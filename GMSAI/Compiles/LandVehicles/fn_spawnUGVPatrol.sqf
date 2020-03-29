/*
	GMSAI_fnc_spawnUGVPatrol 
	
	Purpose: spawn a UGV patrol that will go from location to location on the map hunting for players 

	Parameters: 
		_pos,  			center of the region in which the group will operate 
		_patrolType, 	"Map" or Region, where region would be am area proscribed by a marker defined by center, size and shape 
		_blackListed     positions to be avoided formated as [[x,y,z], radious]
		_center			the center of the patrol area or map center if the mode is "Map"
		_size			The size of the patrol area or mapsize if the mode is "Map" 
		_shape			Normally, this is a rectangle 
		_timeout		how quickly the group is sent back if it wanders out of the mission area.

	Returns: [_group,_ugv]
		_group ( the group spawned) 
		_ugv (the vehicle spawned)

	Copywrite 2020 by Ghostrider-GRG- 

	Notes:
		Locations: are any town, city etc defined at startup. 
*/
#include "\addons\GMSAI\init\GMSAI_defines.hpp"
params[
		"_difficulty",
		"_className",
		"_pos",					// Random position for patrols that roam the whole map 
								// or center of the area to be patrolled for those that are restricted to a smaller region
		["_patrolArea","Map"],  // "Map" will direct the chopper to patrol the entire map, "Region", a smaller portion of the map.
		["_blackListed",[]],  	// areas to avoid within the patrol region
							 	// These parameters are ignored if the chopper will patrol the entire map.
		["_center",[0,0,0]],  	// center of the area to be patroled
		["_size",[200,200]],  	// size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
		["_timeout",300]];  	// The time that must elapse before the antistuck function takes over.]];

private _ugv = createVehicle [_className, _pos, [], 10, "NONE"];
_ugv setFuel 1;
_ugv engineOn true;
_ugv setVehicleLock "LOCKED";
[_ugv] call GMS_fnc_emptyObjectInventory;
private _group = _ugv call GMS_fnc_createUnmanedVehicleCrew;  // Make sure the vehicle faction is the same as the GMS_side faction

[_group,_difficulty] call GMS_fnc_setupGroupSkills;

_ugv addMPEventHandler["MPHit",{if (isServer) then {_this call GMSAI_fnc_processVehicleHit}}];
_ugv addMPEventHandler["MPKilled",{if (isServer) then {_this call GMSAI_fnc_processVehicleKilled}}];
_ugv addEventHandler["HandleDamage",{if (isServer) then {_this call GMSAI_fnc_vehicleHandleDamage}}];
{
	_x addMPEventHandler ["MPKilled", {if (isServer) then {_this call GMSAI_fnc_processVehicleCrewKilled}}];
	_x addMPEventHandler ["MPHit", {if (isServer) then {_this call GMSAI_fnc_processVehicleCrewHit;}}];
	_x addEventHandler["HandleDamage",{if (isServer) then {_this call GMSAI_fnc_vehicleCrewHandleDamage}}];
	_x addEventHandler ["GetOut",{_this call GMSAI_fnc_processVehicleCcrewGetOut;}];
} forEach (crew _ugv);

if (_patrolArea isEqualTo "Map") then 
{
	(driver _ugv) call GMSAI_fnc_initializeVehicleWaypoints;
} else {
	if (_center isEqualTo [0,0,0]) then {_center = _pos};
	[format["[]Patrol _center for UGV group %1 was undefined and was set to %2",_group,_pos],"warning"] call GMSAI_fnc_log;
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

private _return = [_group,_ugv];
_return
