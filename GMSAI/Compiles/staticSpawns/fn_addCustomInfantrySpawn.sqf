/*
	GMSAI_fnc_addCustomInfantrySpawn

	Purpose: provide a function by which server owners can add static infantry patrols to meet their own needs. 

	Parameters: See params list below 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-
	
	Notes: 
	call this as: 
	GMSAI_fnc_addInfantrySpawn[
			_pos,	Center of the patrol area
			_shape,  ["RECCTANGLE","ELLIPSE"] 
			_size,	 [[sizeA,sizeB]/Radius]
			_units,  can be [_min,_max],  [_min], or _min
			_difficulty,  can be 1..N per GMSAI configs.
			_respawns,  0..N, -1 for infinite respawns 
			_cooldown  time in seconds until group respawns
		];

	GMSAI_fnc_addStaticSpawn expects the following parameters 
	params["_areaDescriptor","_staticAiDescriptor"];

	_areaDescriptor params["_patrolAreaMarker","_staticAiDescriptor","_spawnType","_spawnedGroups","_respawnAt","_timesSpawned","_debugMarker"];	
	_staticAiDescriptor params["_noGroupsToSpawn","_unitsPerGroup","_difficulty","_chance","_maxRespawns","_respawnTime", "_despawnTime"];	

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
			[_cooldown,GMSAI_vehiclePatrolDeleteTime],  // time in seconds until group respawns
			[_isSubmerged,false]	//  true/false  when true the swimIndepth will be set to (getPosASL - getPosATL)/2
		];

private _m = createMarkerLocal [_name,_pos];
_m setMarkerShapeLocal _shape;
_m setMarkerSizeLocal _size;	

_aiDescriptor = [_groups,_units,_difficulty,_chance,_respawns,_cooldown,GMSAI_staticDespawnTime,"Man",_isSubmerged];
[_m,_aiDescriptor] call GMSAI_fnc_addStaticSpawn;

	
