/*
	GMSAI_fnc_boostOnNearbyUnitKilled

	Purpose: boost skills of last unit and 
*/
params["_unit","_killer",["_threshold",1]];

if (units group _unit <= GMSAI_boostSkillsLastUnits && GMSAI_boostSkillsLastUnits > 0) then 
{
	[group _unit,0.1,0.1] call GMS_fnc_boostAtributes};
	if !(GMSAI_NotifyNeighboringGroupLastUnit isEqualTo []) then 
	{
		private _ng = private _ng = group(nearestObject[getPosATL _unit,GMS_unitType]);
		if ((side _ng) isEqualTo GMSAI_side) then 
		{
			private _u = _x;
			{
				if ((vehicle _u) isKindOf _x) then 
				{
					_u reveal[_killer, 0.2];
				};
			} forEach GMSAI_NotifyNeighboringGroupLastUnit;	
		} forEach (units _ng);
	} else {
		[_unit,_killer,300,-.2] call GMS_fnc_allertNearestGroup;
	};
}; 