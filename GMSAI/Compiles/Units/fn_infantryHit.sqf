/*
	GMSAI_fnc_infantryHit 

	Purpose: handle GMSAI specific actions when a unit is hit including changing hunting behavior. 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPHit  

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes:
		TODO: need to review this to see what is duplicated from the GMS mpHit EH. 
			That one handles healing if damage > a certain value, 
			throws smoke based ona parameter passed when the group is spawned 
			Knows how many times heals can be done base on a parameter passed when the group is spawned 
			Set the group to compat mode for GMS 

			The only thing left is bumping stats and starting deeper hunting logic. 
		TODO: need to think about what, if anything this should do, such as allerating other nearby groups. 
		Note that the standard GMS hit EH puts the group on alert and I believe increases that groups knowsAbout for the player
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_unit","_causedBy","_damage","_instigator"];
[format["infantryHit _unit = %1 | _instigator = %2",_unit,_instigator]] call GMSAI_fnc_log;
if (!(isPlayer _instigator)) exitWith {};
if (alive _unit) then {
	if ((currentWeapon _instigator) in GMSAI_forbidenWeapons) then {
		_unit setDamage ((damage _unit) - _damage);
	} else {
		(group _unit) reveal[_instigator,1];
		// Possible heal functions here
		if !(_unit getVariable["hasHealed",false]) then
		{
			[_unit,"SmokeShellPurple",_instigator getRelDir _unit] call GMS_fnc_throwSmoke;
			[_unit] call GMS_fnc_healSelf;
			_unit setVariable["hasHealed",true];
		};
	};
	(leader (group _unit)) call GMSAI_fnc_nextWaypoint;	
};
