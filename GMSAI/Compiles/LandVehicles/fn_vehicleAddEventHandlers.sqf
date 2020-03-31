

params["_veh"];

_veh addMPEventHandler["MPHit",{if (isServer) then {_this call GMSAI_fnc_processVehicleHit}}];
_veh addMPEventHandler["MPKilled",{if (isServer) then {_this call GMSAI_fnc_processVehicleKilled}}];
_veh addEventHandler["HandleDamage",{if (isServer) then {_this call GMSAI_fnc_vehicleHandleDamage}}];
{
	_x addMPEventHandler ["MPKilled", {if (isServer) then {_this call GMSAI_fnc_processVehicleCrewKilled}}];
	_x addMPEventHandler ["MPHit", {if (isServer) then {_this call GMSAI_fnc_processVehicleCrewHit;}}];
	_x addEventHandler["HandleDamage",{if (isServer) then {_this call GMSAI_fnc_vehicleCrewHandleDamage}}];
	_x addEventHandler ["GetOut",{_this call GMSAI_fnc_processVehicleCrewGetOut;}];
} forEach (crew _veh);