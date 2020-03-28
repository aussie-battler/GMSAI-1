/*
	Copyright 2020 Ghostrider-GRG-
*/

private _driver = _this;
//diag_log format["_nextWaypointVehicles: _driver = %1",_driver];
private _group = group _driver;
private _veh = vehicle _driver;

_fn_updateVehicleWaypoint = {

};
// TODO: Add antiStuck
if (_group call GMS_fnc_isStuck) exitWith 
{
	private _nearLocations = nearestLocations [position _driver, GMSAI_vehiclePatrolDestinations,3000];
	private _pos = position _veh;
	private _loc = selectRandom _nearLocations;
	private _lastWaypointPos = waypointPosition [_group,0];
	//diag_log format["_nextWaypointVehicles: last waypointPosition = %1",_lastWaypointPos];
	while { (locationPosition _loc) distance _lastWaypointPos < 500 || _veh distance _pos < 500 || (text _loc) in GMSAI_blackListedAreasVehicles} do
	{
		_loc = selectRandom _nearLocations;
		_pos = locationPosition _loc;
	};
	//private _wp = _group addWaypoint [_pos,0,0,format["%1",text _loc]];
	_group setBehaviour "CARELESS";
	_group setCombatMode "BLUE";
	_group setSpeedMode "NORMAL";
	private _wp = [_group,0];
	_wp setWaypointPosition _pos;
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointCombatMode "YELLOW";
	_group setCurrentWaypoint [_group,0]; 	
	[_group,false] call GMS_fnc_setWaypointStuckValue;
	//diag_log format["_nextWaypointVehicles: next waypoint set to location == %1",text _loc];	
};

//diag_log format["_nextWaypointVehicles: moving vehicle %1 to new location",_veh];
private _nearestEnemy =  _driver findNearestEnemy (position (_driver));
if !(isNull _nearestEnemy) then
{
	//diag_log format["_nextWaypointVehicle: _driver = %1 | _group = %2 | _nearestEnemy = %3",_driver,_group,_nearestEnemy];	
	private _nextPos = position _nearestEnemy getPos[ [5,20/(_driver knowsAbout _nearestEnemy)] call GMS_fnc_getNumberFromRange,random(359)];
	//diag_log format["_nextWaypointVehicle: enemies detected, configuring SAD waypoint at _nextPos = %1",_nextPos];	
	_group setVariable["timeStamp",diag_tickTime];	
	private _wp = [_group,0];
	_wp setWaypointPosition [_nextPos,5];
	_wp setWaypointType "SAD";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointTimeout [45,60,75];	
	_group setCurrentWaypoint _wp;
	//diag_log format["GMSAI_fnc_nextWaypointVehicle: waypoint for group %1 updated to SAD waypoint at %2",_group,_nextPos];
} else {
	private _nearLocations = nearestLocations [position _driver, GMSAI_vehiclePatrolDestinations,3000];
	private _pos = position _veh;
	private _loc = selectRandom _nearLocations;
	private _lastWaypointPos = waypointPosition [_group,0];
	//diag_log format["_nextWaypointVehicles: last waypointPosition = %1",_lastWaypointPos];
	while { (locationPosition _loc) distance _lastWaypointPos < 500 || _veh distance _pos < 500 || (text _loc) in GMSAI_blackListedAreasVehicles} do
	{
		_loc = selectRandom _nearLocations;
		_pos = locationPosition _loc;
	};
	private _wp = _group addWaypoint [_pos,0,0,format["%1",text _loc]];
	_wp setWaypointPosition[_pos,10];
	_wp setWaypointTimeout[5,7,9];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointStatements ["true","this call GMSAI_fnc_nextWaypointVehicles;"];	
	_group setCurrentWaypoint [_group,0]; 	
	//diag_log format["_nextWaypointVehicles: next waypoint set to location == %1",text _loc];
};	
