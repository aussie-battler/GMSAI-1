/*	
	GMSAI_fnc_addStaticspawn

	Purpose: add a spawn for infantry within a speciried area.
	
	Parameters: 
		_areaDescriptor,  Information about the map marker/location, size etc
		_staticAiDescriptor, information about the AI to be spawned 

	Returns: None 

	Copyright 2020 Ghostrider-GRG-

	Notes:
		TODO: need to confirm the nature of the two parameters but I think the description of them is correct	
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
//diag_log format["[GMSAI] _addStaticAiSpawn: _this = %1",_this];
params["_areaDescriptor","_staticAiDescriptor"];

#define respawnAt 0
#define timesSpawned 0
//diag_log format["[GMSAI] adding static spawn with area descriptor of %1 | _staticAiDescriptor of %2",_areaDescriptor,_staticAiDescriptor];
GMSAI_StaticSpawns pushBack [_areaDescriptor, _staticAiDescriptor, GMSAI_infantry, [grpNull],respawnAt, timesSpawned];
