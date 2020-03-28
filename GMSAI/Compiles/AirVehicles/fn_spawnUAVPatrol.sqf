	
/*
	GMS_fnc_spawnUAVPatrol 
	Purpose: spawn a UAV patrol that will go from location to location on the map hunting for players 
	Locations: are any town, city etc defined at startup. 
	Copywrite 2020 by Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp"  
diag_log format["[GMSAI] _fnc_spawnUAVPatrol: _this = %1",_this];
params["_pos",					// Random position for patrols that roam the whole map 
								// or center of the area to be patrolled for those that are restricted to a smaller region
		["_patrolType","Map"],  // "Map" will direct the chopper to patrol the entire map, "Region", a smaller portion of the map.
		["_blackListed",[]],  // areas to avoid within the patrol region
							 // These parameters are ignored if the chopper will patrol the entire map.
		["_center",[0,0,0]],  // center of the area to be patroled
		["_size",[200,200]],  // size of the area to be patroled, either a value or array of 2 values
		["_shape","RECTANGLE"],  // "RECTANGLE" or "ELLIPSE"
		["_timeout",300]];  // The time that must elapse before the antistuck function takes over.]];

private _uav = createVehicle [selectRandomWeighted GMSAI_UAVTypes, _pos, [], 0, "FLY"];
diag_log format["[GMSAI] _fnc_spawnUAVPatrol: UAV selected = %1",_uav];
_uav setFuel 1;
_uav engineOn true;
_uav flyInHeight 100;
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

if (_patrolType isEqualTo "Map") then 
{
	//group setVariable["GMSAI_blacklistedLocations",_blackListed];		
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
	[format["[]Patrol _center for UAV group %1 was undefined and was set to %2",_group,_pos],"warning"] call GMSAI_fnc_log;	
	[_group,_blacklisted,_center,_size,_shape,_timeout] call GMS_fnc_initializeWaypoints;
	// Note: the group is added to the list of groups monitored by GMS. Empty groups are deleted, 'stuck' groups are identified.
};
private _return = [_group,_uav];
_return