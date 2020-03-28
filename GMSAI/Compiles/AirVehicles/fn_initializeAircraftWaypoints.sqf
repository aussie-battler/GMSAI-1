/*
	GMSAI_fnc_initializeAircraftWaypoints 

	Purpose: Initialize the waypoint system for air patrols. 

	Parameters: 
		_group, the group for which the waypoints are to be initialized 

	Returns: None
	
	Copyright 2020 Ghostrider-GRG-

	Notes:
		GMSAI_fnc_nextWaypointAircraft Uses a location-based method for finding waypoints 
		so that those pesky helis will circle overhead at interesting objectives for a bit. 
		Includes a hunting function by which helis will pursue targets until killed or called back.	
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_group"]; 
private _wp = [_group,0]; 
_wp setWaypointStatements ["true","this call GMSAI_fnc_nextWaypointAircraft;"];
(leader _group) call GMSAI_fnc_nextWaypointAircraft;