/*
	GMSAI_fnc_nextWaypointAircraft 

	Purpose: Set the next waypoint for an aircraft patrol (UAV or otherwise)

	Parameters: None  

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes:
		Uses a location-based method for finding waypoings so that those pesky helis will circle overhead at interesting objectives for a bit. 
		Includes a hunting function by which helis will pursue targets until killed or called back.
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
[format["nextWaypointAircraft: _this = %1 | typeName _this 5 %2",_this,typeName _this]] call GMSAI_fnc_log;
private _leader = _this;
private _group = group _leader;

// If the timestamp has not bee updated for a while then find a new waypoint

if ([_group] call GMS_fnc_isStuck) exitWith 
{

	// Group is stuck so handle that 
	// Need group to disengage as well.

	private _nearLocations = nearestLocations [
		position _leader, 
		GMSAI_aircraftPatrolDestinations,
		5000
	];
	private _pos = position _leader;
	private _loc = selectRandom _nearLocations;  // where the aircraft should move
	private _lastWaypointPos = waypointPosition [_group,0];
	while { (locationPosition _loc) distance _lastWaypointPos < 1500 || _leader distance _pos < 1500 || (text _loc) in GMSAI_blackListedAreasVehicles} do
	{
		_loc = selectRandom _nearLocations;
		_pos = locationPosition _loc;
	};	

	[_group,"disengage"] call GMS_fnc_setGroupBehaviors;
	//_group setBehaviour "CARELESS";
	//_group setCombatMode "BLUE";
	_group setSpeedMode "NORMAL";

	private _wp = [_group,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointTimeout [0.1, 0.2, 0.3]; // want this to roll over to a normal waypoint soon after it is reached.
	_wp setWaypointPosition _pos;
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointCombatMode "YELLOW";
	_group setCurrentWaypoint [_group,0]; 	
	[_group,false] call GMS_fnc_setWaypointStuckValue;
};

private _nearestEnemy = objNull;
private _target = _group getVariable["target",objNull];
if !(_target isEqualTo objNull) then 
{
	if (alive _target) then 
	{
		_nearestEnemy = _target;
	} else {
		_nearestEnemy =  _leader findNearestEnemy (position (_leader));
	};
} else {
	_nearestEnemy =  _leader findNearestEnemy (position (_leader));
};

if !(isNull _nearestEnemy) then
{

	// If there are enemies near then set a waypoint to them and engage

	_group setVariable["target",_nearestEnemy];
	// TODO: revisit the logic here
	_pos = position _nearestEnemy getPos[ [3,30/(_leader knowsAbout _nearestEnemy)] call GMS_fnc_getNumberFromRange,random(359)];
	_group setVariable["timeStamp",diag_tickTime];	
	private _wp = [_group,0];
	_wp setWaypointPosition [_pos,5];
	_wp setWaypointType "SAD";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointTimeout [45,60,75];

	[_group,"combat"] call GMS_fnc_setGroupBehaviors;
	_group setSpeedMode "LIMITED";

	_group setCurrentWaypoint _wp;
	diag_log format["_nextWaypointAircraft: waypoint for group %1 updated to SAD waypoint at %2",_group,_pos];
} else {
	
	// No enemies so treat like a normal waypoint.

	private _nearLocations = nearestLocations [
		position _leader,
		GMSAI_aircraftPatrolDestinations,
		5000
	];
	private _pos = position _leader;
	private _loc = selectRandom _nearLocations;
	private _lastWaypointPos = waypointPosition [_group,0];
	//diag_log format["_nextWaypointVehicles: last waypointPosition = %1",_lastWaypointPos];
	while { (locationPosition _loc) distance _lastWaypointPos < 500 || _leader distance _pos < 500 || (text _loc) in GMSAI_blackListedAreasVehicles} do
	{
		_loc = selectRandom _nearLocations;
		_pos = locationPosition _loc;
	};	
	//diag_log format["_nextWaypointAircraft: _pos = %1",_pos];
	_group setVariable["timeStamp",diag_tickTime];
	
	// just in case they were changed before this waypoint was completed.
	[_group,""] call GMS_fnc_setGroupBehaviors;  
	_group setSpeedMode "LIMITED";
	
	private _wp = [_group, 0];
	_wp setWaypointPosition [_pos,5];
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointLoiterRadius 150;
	_wp setWaypointType "LOITER";
	_wp setWaypointLoiterType "CIRCLE_L";
	_wp setWaypointTimeout  [15,20,25];
	_group setCurrentWaypoint _wp;
	//diag_log format["_nextWaypointAircraft: waypoint for group updated to LOITER waypoint at %2",_group,_pos];
};