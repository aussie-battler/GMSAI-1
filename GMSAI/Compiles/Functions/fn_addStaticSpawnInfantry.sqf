/*	GMSAI_fnc_addStaticspawnInfantry

	Purpose: add a spawn for infantry within a speciried area.
	Purpose: add a spawn for infantry within a speciried area.
*/
//diag_log format["[GMSAI] _addStaticAiSpawn: _this = %1",_this];
params["_areaDescriptor","_staticAiDescriptor"];
#define respawnAt 0
#define timesSpawned 0
//diag_log format["[GMSAI] adding static spawn with area descriptor of %1 | _staticAiDescriptor of %2",_areaDescriptor,_staticAiDescriptor];
GMSAI_StaticSpawns pushBack [_areaDescriptor, _staticAiDescriptor, GMSAI_infantry, [grpNull],respawnAt, timesSpawned];
true