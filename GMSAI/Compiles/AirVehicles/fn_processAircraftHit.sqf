/*
	GMSAI_fnc_processAircraftHit 

	Purpose: called when the MPHit event handler fires for the aircraft 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPHit  

	Returns: None 

	Copyright 2020 Ghostrider-GRG-

	Notes:
	TODO: think about how to add hunting logic here and if any is needed beyond that for nextWaypointAircraft
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_aircraft","_causedBy","_damage","_instigator"];
diag_log format["[GMSAI] processAircraftHit _unit = %1 | _instigator = %2",_unit,_instigator];
_group = group((crew _aircraft) select 0);
private _group = group ((crew _aircraft) select 0);
_group reveal[_instigator,((_group knowsabout _instigator) + ([_group] call GMS_fnc_getGroupIntelligence))];
(driver _aircraft) call GMSAI_fnc_nextWaypointAircraft;