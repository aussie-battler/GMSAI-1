/*
	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_group"];
{
	_x addEventHandler ["Reload", {_this call GMSAI_fnc_infantryReloaded;}];
	_x addMPEventHandler ["MPKilled", {[(_this select 0), (_this select 1)] call GMSAI_fnc_infantryKilled;}];
	_x addMPEventHandler ["MPHit",{_this call GMSAI_fnc_infantryHit;}];
} forEach (units _group);
[format["addEventHandlersInfantry: event handlers added for group %1",_group]] call GMSAI_fnc_log;