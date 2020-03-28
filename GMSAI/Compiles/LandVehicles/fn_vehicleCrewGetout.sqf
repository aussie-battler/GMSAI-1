/*
	Scope global 
	Only fires on the machin to which the object is local. 
	This function needs to be available on every machine in some way if HC and distribution to clients is to be supported.
*/

params["_vehicle"];
if (local _vehicle) then 
{
	if ({alive _x} count (crew _vehicle) isEqualTo 0) then
	{
		[_vehicle] call GMSAI_fnc_processEmptyVehicle;
	};
};