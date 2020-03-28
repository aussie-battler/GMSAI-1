/*
	GMS_fnc_processAircraftCrewMPeHit 
	- Damage due to collisions is handled elsewhere.
	- otherwise the script informst the group about the instigator and runs a new waypoint update which will automatically include targeting the nearest known enemy.

	Copyright 2020 by Ghostrider-GRG-
*/

params["_unit","_causedBy","_damage","_instigator"];
[format["processAircraftCrewHit: _unit %1 hit by %2",_unit,_causedBy]] call GMSAI_fnc_log;
_group reveal[_instigator,((group _unit) knowsabout _instigator) + ([_group] call GMS_fnc_getGroupIntelligence)];

if ((currentWeapon _instigator) in GMSAI_forbidenWeapons) then 
{
	_unit setDamage ((damage _unit) - _damage);
};
(leader (group _unit)) call GMSAI_fnc_nextWaypointAircraft;
