params["_aircraft","_causedBy","_damage","_instigator"];
diag_log format["[GMSAI] processAircraftHit _unit = %1 | _instigator = %2",_unit,_instigator];
_group = group((crew _aircraft) select 0);
private _group = group ((crew _aircraft) select 0);
_group reveal[_instigator,((_group knowsabout _instigator) + ([_group] call GMS_fnc_getGroupIntelligence))];
(driver _aircraft) call GMSAI_fnc_nextWaypointAircraft;