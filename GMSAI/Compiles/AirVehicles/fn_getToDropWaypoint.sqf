/*

	GMSAI_fnc_getToDropWaypoint
	
	Purpose: have the aircraft fly to the dropoff then come to a slow loiter 

	Parameters: _this is the leader of the group crewing the aircraft 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes: 	

*/
private _group = group _this;
private _dropPos = _group getVariable "dropPos";
_group setSpeedMode "NORMAL";
[_group,"disengage"] call GMS_fnc_setGroupBehaviors;
private _wp = [_group,0];
_wp setWaypointCompletionRadius 10;
_wp setWaypointBehaviour "AWARE";
_wp setWaypointCombatMode "YELLOW";
_wp setWaypointSpeed "LIMITED";
_wp setWaypointPosition  [_dropPos,0];
_wp setWaypointTimeout [0,0.5,1];
_wp setWaypointType "LOITER";
_wp setWaypointStatements ["true","this call GMSAI_fnc_hoverWaypoint;"];
_group setCurrentWaypoint _wp;
