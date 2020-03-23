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
