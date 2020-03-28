/*
	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_group","_aircraft","_target"];
[[format["dropReinforcements called: _group = %1 | _aircraft = %2 | _target = %3",_group,_aircraft,_target]]] call GMSAI_fnc_log;

private _dropPos = getPosATL(leader _group); // the drop pos would be near the location of the flight crew when reinforcements are called in. 
private _difficulty = selectRandomWeighted GMSAI_paratroopDifficulty;
private _paraGroup = [
	[0,0,0],
	[GMSAI_numberParatroops] call GMS_fnc_getIntegerFromRange,
	GMS_side,
	GMSAI_baseSkilByDifficulty select _difficulty,
	GMSA_alertDistanceByDifficulty select _difficulty,
	GMSAI_intelligencebyDifficulty select _difficulty,
	false
] call GMS_fnc_spawnInfantryGroup;

[_group,GMSAI_unitDifficulty select (_difficulty)] call GMS_fnc_setupGroupSkills;
[_group, GMSAI_unitLoadouts select _difficulty, 0 /* launchers per group */, GMSAI_useNVG, GMSAI_blacklistedGear] call GMS_fnc_setupGroupGear;
[_group,_difficulty,GMSAI_money] call GMS_fnc_setupGroupMoney;
[_group,GMSAI_bodyDeleteTimer] call GMS_fnc_setGroupBodyDespawnTime;
[_group] call GMSAI_fnc_addEventHandlersInfantry;
GMSAI_paratroopGroups pushBack _paraGroup;

[[format["dropReinforcements: _paraGroup %1",_paraGroup]]] call GMSAI_fnc_log;

_paraGroup reveal[_target,4];
_paraGroup setVariable["target",_target];
_paraGroup setVariable["targetGroup",group _target];
// spawn this so other functions of GMSAI are not held up.
[_group,getPosATL _aircraft,_target] call GMS_fnc_dropParatroops;


