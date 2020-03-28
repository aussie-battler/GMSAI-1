/*
	GMSAI_fnc_monitorDeadUnits 

	Purpose: ensure cleanup of dead AI 

	Parameters: None 

	Return: None 
	
	Copyright 2020 Ghostrider-GRG-

	Notes 
		Probably not needed since GMS handles this using deleteAt times passed to it by GMSAI 
		in GMS_fnc_spawnInfantryGroup
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
for "_i" from 1 to (count GMSAI_deadAI) do
{
	_v = GMSAI_deadAI deleteAt 0;
    if (_i > (count GMSAI_deadAI)) exitWith {};
    if (diag_tickTime > _v getVariable "GMSAI_deleteAt") then 
	{
			deleteVehicle _v;
	} else {
		GMSAI_deadAI pushBack _v;
	};
};