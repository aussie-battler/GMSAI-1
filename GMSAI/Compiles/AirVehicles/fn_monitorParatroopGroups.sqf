/*
	GMSAI_fnc_monitorParatroopGroups
	Purpose: monitor para groups to keep them hunting till nothing is left then despawn them.

	Parameters: None 

	Returns: None 
	
	Copyright 2020 Ghostrider-GRG-
*/

/*
	possible actions:
	1. Delete if all units dead or the target and other known enemies are dead. 
	2. the group knows about the target and should keep hunting it.
	3. The target is down but other enemies are near and the group should hunt them. 
	4. there are no enemies near and the target is down and the time elapsed is > than depawn timer


*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
diag_log format["_fnc_monitorParatroopGroups: called at %1",diag_tickTime];

for "_i" from 1 to (count GMSAI_paratroopGroups) do
{
	if (_i > (count GMSAI_paratroopGroups)) exitWith {};
	private _group = GMSAI_paratroopGroups deleteAt 0;
	// case of empty or null group. 
	if (isNull _group || (units _group) isEqualTo []) then 
	{
		//if ( isNull _group) then {};
		if ((units _group) isEqualTo []) then {deleteGroup _group};  
	} else {
		private _target = _group getVariable "target";
		if !(alive _target) then // continue hunting the target 
		 {  // see if there are other known enemies nearby and if so hunt the nearest
			private _e = (leader _group) findNearestEnemy (getPosATL (leader _group));
			if !(isNull _e) then 
			{
				_target = _e;
				_group setVariable["target",_target];
			};
			if (isNull _target || !(alive _target)) then 
			{
				private _lastSeen = _group getVariable "playerLastDetected";
				if (isNil _lastSeen) then 
				{
					_group setVariable["playerLastDetected",diag_tickTime];
				};
			};
		};
		if (alive _target) then 
		{
			// hunt 
			//[_group,_target] call GMSAI_fnc_hunt;
			_group setVariable["playerLastDetected",diag_tickTime];
			GMSAI_paratroopGroups pushBack _group;
		};
	};
};

