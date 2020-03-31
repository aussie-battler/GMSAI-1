/*
	GMS_fnc_spawnVehiclePatrol 
	Purpose: spawn a vehicle patrol that will go from location to location on the map or patrols a proscribed area hunting for players 
	
		Parameters: 
		_pos,  			center of the region in which the group will operate 
		_patrolType, 	"Map" or Region, where region would be am area proscribed by a marker defined by center, size and shape 
		_blackListed     positions to be avoided formated as [[x,y,z], radious]
		_center			the center of the patrol area or map center if the mode is "Map"
		_size			The size of the patrol area or mapsize if the mode is "Map" 
		_shape			Normally, this is a rectangle 
		_timeout		how quickly the group is sent back if it wanders out of the mission area.
		_isSubmersible  true/false  When true, and if the vehicle is on or in water, it will be set to move below the surface 
		
	Returns: [_group,_vehicle]
		_group ( the group spawned) 
		_vehicle (the vehicle spawned)

	Copywrite 2020 by Ghostrider-GRG- 

	Notes:
		Locations: are any town, city etc defined at startup.
		when '_isSubmersible == true the script will assume it should set swimInDepth as well
		Locations: are any town, city etc defined at startup. 
 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp"
params[
		"_difficulty",
		"_classname",			// className of vehicle to spawn
		"_pos",					// Random position for patrols that roam the whole map 
								// or center of the area to be patrolled for those that are restricted to a smaller region
		["_patrolArea","Map"],  // "Map" will direct the vehicle to patrol the entire map, "Region", a smaller portion of the map.
		["_blackListed",[]],  	// areas to avoid within the patrol region
							 	// These parameters are ignored if the vehicle will patrol the entire map.
		//  DefinedByPatrolArea, a marker ["_center",[0,0,0]],  	// center of the area to be patroled
		//  DefinedByPatrolArea, a marker["_size",[200,200]],  	// size of the area to be patroled, either a value or array of 2 values
		//  DefinedByPatrolArea, a marker["_size",[200,200]],  	// size of the area to be patroled, either a value or array of 2 values
		//  DefinedByPatrolArea, a marker["_shape","RECTANGLE"], // "RECTANGLE" or "ELLIPSE"
		["_timeout",300],		// The time that must elapse before the antistuck function takes over.]];
		["_isSubmersible",false]  //  when true, the swimIndepth will be set to (ASL - AGL)/2
	];  
// selectRandomWeighted GMSAI_patrolVehicles
private _vehicle = createVehicle [_className, _pos, [], 10, "NONE"];
[_vehicle] call GMS_fnc_emptyObjectInventory;
private _crewCount = [GMSAI_patroVehicleCrewCount] call GMS_fnc_getIntegerFromRange;
//private _difficulty = selectRandomWeighted GMSAI_vehiclePatroDifficulty;
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

[_vehicle] call GMSAI_fnc_vehicleAddEventHandlers;

if (_isSubmersible) then 
{
	// set the swimindept to 1/2 the height of surface level above ground leve of the driver of the vehicle
	_driver swimInDepth (((getPosATL(ASLtoATL(getPosASL(driver _vehicle))) ) select 2)/2);
};
if (_patrolArea isEqualTo "Map") then 
{
	(driver _vehicle) call GMSAI_fnc_initializeVehicleWaypoints;
} else {
	#define addGrouptoMonitoredGroups true
	if (_center isEqualTo [0,0,0]) then {_center = _pos};
	[format["[]Patrol _center for vehicle group %1 was undefined and was set to %2",_group,_pos],"warning"] call GMSAI_fnc_log;
	[_group,_blacklisted,_patrolArea,_timeout] call GMS_fnc_initializeWaypointsAreaPatrol;
	// Note: the group is added to the list of groups monitored by GMS. Empty groups are deleted, 'stuck' groups are identified.
};

private _return = [_group,_vehicle];
_return
