/*
	GMS_fnc_processVehicleHit 
	- damage due to collisions is handled elsewhere.
	- otherwise the script informst the group about the instigator and runs a new waypoint update which will automatically include targeting the nearest known enemy.

	Copyright 2020 by Ghostrider-GRG-
*/

params["_vehicle","_causedBy","_damage","_instigator"];

private _vehicle = vehicle _unit;
private _group = group ((crew _vehicle) select 0);
_group reveal[_instigator,((_group knowsabout _instigator) + ([_group] call GMS_fnc_getGroupIntelligence))];
(leader (group _unit)) call GMSAI_fnc_nextWaypointVehicles;