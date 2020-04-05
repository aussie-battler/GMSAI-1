/*
	GMSAI_fnc_addEventHandlersInfantry 

	Purpose: add stacked EH to units.

	Parameters: _group, the group for which you wish to add EH to the units. 

	Returns: none 
	
	Copyright 2020 Ghostrider-GRG-

	Notes: 
	 	these EH perform GMSAI=specific functions for MPHit, MPKilled, reload.
		a handleDamage EH is already added by GMS so is not needed here. 
		This EH just has to deal with hunting, player notifications, etc. 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_group"];
{
	//_x addEventHandler ["Reload", {_this call GMSAI_fnc_infantryReloaded;}];
	_x addMPEventHandler ["MPKilled", {[(_this select 0), (_this select 1)] call GMSAI_fnc_infantryKilled;}];
	_x addMPEventHandler ["MPHit",{_this call GMSAI_fnc_infantryHit;}];
} forEach (units _group);
[format["addEventHandlersInfantry: event handlers added for group %1",_group]] call GMSAI_fnc_log;