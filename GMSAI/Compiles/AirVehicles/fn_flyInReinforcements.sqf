/*
	GMSAI_fnc_flyInReinforcements 

	Purpose: fly in a heli and drop reinforcements by parachute at a specified location 

	Parameters: 
		_dropPos, where the drop should occure 
		_group, the group the be dropped 
		_targetedPlayer, the player target to be hunted by the reinforcements 

	Returns: None 
	
	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_dropPos","_group","_targetedPlayer"];
[format["flyInReinforcements CALLED"]] call GMSAI_fnc_log;
/*
	steps to follow for this script:
	1. set a position under the aircraft detecting the player for dropoff 
	  and set the respawn timer stored on the object to respawnInterval + diagTickTime
	2. spawn in a group, set damage = false, and equip, holding them at [0,0,0]
	3. pass the dropoff position and group info to the script in GSM core functions
	4. once all units are on the ground, pass control of the group off to group manager and paratroop manager

*/

// make sure no other reinforcements are called in for a while
_group setVariable[respawnParaDropAt, diag_tickTime + GMSAI_paratroopRespawnTimer];
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

// spawn this function so it does not hold up other functions of GMSAI
[_dropPos,selectRandomWeighted GMSAI_paratroopAircraftTypes, _group] call GMS_fnc_flyInCargoToLocation;
GMSAI_paratroopGroups pushBack _paraGroup;
