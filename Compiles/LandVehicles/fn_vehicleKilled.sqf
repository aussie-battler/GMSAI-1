/*
	GMS_fnc_processVehicleHit 
	- if damage was not due to a player then damage is negated and the script exits 
	- otherwise the script informst the group about the instigator and runs a new waypoint update which will automatically include targeting the nearest known enemy.

	Copyright 2020 by Ghostrider-GRG-
*/

params["_vehicle"];
[_vehicle,240] call GMS_fnc_addObjectToDeletionCue;