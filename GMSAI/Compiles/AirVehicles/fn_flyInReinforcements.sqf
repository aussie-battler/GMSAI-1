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
params["_dropPos","_group",["_targetedPlayer",ObjNull]];
[format["flyInReinforcements CALLED: _dropPos = %1 | _group = %2 | _targetedPlayer = %3",_dropPos,_group,_targetedPlayer]] call GMSAI_fnc_log;
/*
	steps to follow for this script:
	1. set a position under the aircraft detecting the player for dropoff 
	  and set the respawn timer stored on the object to respawnInterval + diagTickTime
	2. spawn in a group, set damage = false, and equip, holding them at [0,0,0]
	3. pass the dropoff position and group info to the script in GSM core functions
	4. once all units are on the ground, pass control of the group off to group manager and paratroop manager

	TODO: test if this is used.
	TODO: Add 'gunship' option that specifies that the heli will patrol the area and try to take out any players spotted.
*/

// make sure no other reinforcements are called in for a while

//private _dropPos = getPosATL(leader _group); // the drop pos would be near the location of the flight crew when reinforcements are called in. 
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
// TODO: Add GMSAI Event Handlers when these are ready
[_group,GMSAI_unitDifficulty select (_difficulty)] call GMS_fnc_setupGroupSkills;
[_group, GMSAI_unitLoadouts select _difficulty, 0 /* launchers per group */, GMSAI_useNVG] call GMS_fnc_setupGroupGear;
[_group,_difficulty,GMSAI_money] call GMS_fnc_setupGroupMoney;

private _transport = [_difficulty, selectRandomWeighted GMSAI_paratroopAircraftTypes, _dropPos] call GMSAI_spawnHelicoptorPatrol;
_transport params["_transportCrew","_transportAircraft"];
_transportCrew setVariable["dropPos",_dropPos];
_transportCrew setVariable["target",_target];
_transportCrew setVariable["gunship",GMSAI_paratroopTransportIsGunship];
_transportCrew setVariable["difficulty",_difficulty];
(leader _transportCrew) call GMSAI_getToDropWaypoint; 