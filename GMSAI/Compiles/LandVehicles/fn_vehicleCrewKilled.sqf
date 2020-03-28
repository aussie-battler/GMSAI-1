/*
	Just need to alert the crew and maybe any other units 
	and notify player and send any rewards. 

	body cleanup, removal of event handlers and disabling AI behaviors is handled by GMSCore
*/
params["_unit","_killer","_instigator"];
private _vehicle = vehicle _unit;
private _group = group _unit;
_group reveal[
	_instigator,
	((_group knowsabout _instigator) + [_group] call GMS_fnc_getGroupIntelligence)
];
(leader(group _unit)) call GMSAI_fnc_nextWaypointVehicles;

if ((currentWeapon _instigator) in GMSAI_forbidenWeapons) exitWith
{
	_unit setDamage 0;
};

[_unit,_killer,true] call GMSAI_fnc_processUnitKill;

