	
/*
	GMS_fnc_spawnUAVPatrol 
	Purpose: spawn a UAV patrol that will go from location to location on the map hunting for players 

	Parameters: 
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
		_uav, the UAV spawned selected by selectRandomWeighted GMSAI_aircraftTypes,  
	]

	Copywrite 2020 by Ghostrider-GRG-

	Notes: 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp"  
diag_log format["[GMSAI] _fnc_spawnUAVPatrol: _this = %1",_this];
params[
		"_drone",				// classname of the drone to use
		"_pos",					// Random position for patrols that roam the whole map 
								// or center of the area to be patrolled for those that are restricted to a smaller region
		["_patrolArea","Map"],  // "Map" will direct the chopper to patrol the entire map, "Region", a smaller portion of the map.
		["_blackListed",[]],  	// areas to avoid within the patrol region
							 	// These parameters are ignored if the chopper will patrol the entire map.
		["_center",[0,0,0]],  	// center of the area to be patroled
		["_size",[200,200]],  	// size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"], // "RECTANGLE" or "ELLIPSE"
		["_timeout",300]  		// The time that must elapse before the antistuck function takes over.]];
];

private _uav = createVehicle [_drone, _pos, [], 0, "FLY"];
diag_log format["[GMSAI] _fnc_spawnUAVPatrol: UAV selected = %1",_uav];
_uav setFuel 1;
_uav engineOn true;
_uav flyInHeight 50;
_uav setVehicleLock "LOCKED";
[_uav] call GMS_fnc_emptyObjectInventory;
private _group = _uav call GMS_fnc_createUnmanedVehicleCrew;
(driver _uav)  doMove (_pos getPos[3000,random(359)]); 
private _difficulty = selectRandomWeighted GMSAI_UAVDifficulty;
[_group,GMSAI_unitDifficulty select (_difficulty)] call GMS_fnc_setupGroupSkills;
[_group] call GMS_fnc_setupGroupBehavior;
_uav addMPEventHandler["MPHit",{_this call GMSAI_fnc_processAircraftHit}];
_uav addMPEventHandler["MPKilled",{_this call GMSAI_fnc_processVehicleKilled}];
_uav addEventHandler["HandleDamage",{_this call GMSAI_fnc_vehicleHandleDamage}];
{
	_x addMPEventHandler ["MPKilled", {_this call GMSAI_fnc_processAircraftCrewKilledi;}];
	_x addMPEventHandler ["MPHit", {_this call GMSAI_fnc_processAircraftCrewHit;}];
	_x addEventHandler ["GetOut",{_this call GMSAI_fnc_processVehicleCrewGetOut;}]	
} forEach (crew _uav);

if (_patrolArea isEqualTo "Map") then 
{
	//group setVariable["GMSAI_blacklistedLocations",_blackListed];		
	(_group) call GMSAI_fnc_initializeAircraftWaypoints;  // setup waypoint statements server side to avoid BE issues down the road.
} else {
	if (_center isEqualTo [0,0,0]) then {_center = _pos};
	[format["[]Patrol _center for UAV group %1 was undefined and was set to %2",_group,_pos],"warning"] call GMSAI_fnc_log;
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
private _return = [_group,_uav];
_return