/*
	GMSAI_fnc_hoverWaypoint 

	Purpose: brings the aircraft down to a slow spead, sets behavior to normal patrolling behavior, calls the drop waypoint.

	Parameters: _this is the leader of the group crewing the aircraft 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes: 	while this is a short script that could be combined with the dropParasWaypoint, having it separate makes sense logically and breaks up the steps a bit by script.
*/

private _group = group _this;
//_group setSpeedMode "NORMAL";
[_group,"default"] call GMS_fnc_setGroupBehaviors;
private _wp = [_group,0];
_wp setWaypointCompletionRadius 10;
_wp setWaypointBehaviour "AWARE";
_wp setWaypointCombatMode "YELLOW";
_wp setWaypointSpeed "LIMITED";
_wp setWaypointPosition  [_group getVariable "dropPos",0];
_wp setWaypointTimeout [0,2.5,5];
_wp setWaypointType "LOITER";
_wp setWaypointStatements ["true","this call GMSAI_fnc_dropParasrWaypoint;"];
_group setCurrentWaypoint _wp;