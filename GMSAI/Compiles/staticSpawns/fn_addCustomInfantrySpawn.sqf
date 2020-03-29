/*


	Notes: call this as: 
	GMSAI_fnc_addInfantrySpawn[
			_pos,	Center of the patrol area
			_shape,  ["RECCTANGLE","ELLIPSE"] 
			_size,	 [[sizeA,sizeB]/Radius]
			_units,  can be [_min,_max],  [_min], or _min
			_difficulty,  can be 1..N per GMSAI configs.
			_respawns,  0..N, -1 for infinite respawns 
			_cooldown  time in seconds until group respawns
		];

	GMSAI_fnc_addStaticSpawnInfantry expects the following parameters 
	params["_areaDescriptor","_staticAiDescriptor"];

	_areaDescriptor params["_patrolAreaMarker","_staticAiDescriptor","_spawnType","_spawnedGroups","_respawnAt","_timesSpawned","_debugMarker"];	
	_staticAiDescriptor params["_noGroupsToSpawn","_unitsPerGroup","_difficulty","_chance","_maxRespawns","_respawnTime", "_despawnTime"];	

	Steps:
		1. Define a marker 
		2. Configure _areaDescriptor 
		2. define staticAiDescriptor

*/

params[
			_name,  // Must be a unique name
			_pos,	//Center of the patrol area
			_shape,  //["RECCTANGLE","ELLIPSE"] 
			_size,	 //[sizeA,sizeB]/Radius]
			_groups, //[_min,_max], [_min], _min
			_units,  // can be [_min,_max],  [_min], or _min
			_difficulty, // can be 1..N per GMSAI configs.
			_respawns,  // 0..N, -1 for infinite respawns 
			_cooldown  // time in seconds until group respawns
		];

private _m = createMarker[_name,_pos];
_m setMarkerShape _shape;
_m setMarkerSize _size;

if (GMSAI_debug > 1) then
{
	_m setMakerColor "Drab Olive";
	_m setMarkerBrush "SolidBorder";
};
_aiDescriptor = [_groups,_units,_difficulty,_chance,_respawns,_cooldown,GMSAI_staticDespawnTime];
[_m,_aiDescriptor] call GMSAI_fnc_addStaticSpawnInfantry;

	
