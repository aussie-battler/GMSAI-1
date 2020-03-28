/*
	GMSAI_fnc_nextWaypointAircraft 
	Uses a location-based method for finding waypoings so that those pesky helis will circle overhead at interesting objectives for a bit. 
	Includes a hunting function by which helis will pursue targets until killed or called back.
*/

params["_group"]; 
private _wp = [_group,0]; 
_wp setWaypointStatements ["true","this call GMSAI_fnc_nextWaypointAircraft;"];
(leader _group) call GMSAI_fnc_nextWaypointAircraft;