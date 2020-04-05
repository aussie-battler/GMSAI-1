/*
	Purpose: drop paratroops then either patrol as a gunship or leave for destruction elsewhere. 

	Parameters: _this is the leader of the group crewing the aircraft. 

	Returns: none 
	
	Copyright 2020 Ghostrider-GRG-

	Notes: 

*/

private _group = group _this;

_group setSpeedMode "LIMITED";
private _dropPos = _group getVariable "dropPos";
private _aircraft = vehicle ((units _group) select 0);
private _target = _group getVariable "target";
private _difficulty = _group getVariable "difficulty";

[_group,"default"] call GMS_fnc_setGroupBehaviors;
// params["_flightCrewGroup","_aircraft","_target"];
[
	_group,
	_aircraft, 
	_target
] call GMSAI_fnc_dropReinforcements;

uiSleep 5;
if (_group getVariable["gunship",false]) then 
{
	_group setVariable["groupType","air"];
	private "_m";
	if (GMSAI_debug >= 1) then 
	{
		[_group] call GMSAI_fnc_addGroupDebugMarker;
		_m = createMarker[
			format["gunship%1",diag_tickTime],
			_dropPos
		];		
		_m setMarkerShape "RECTANGLE";
		_m setMarkerSize [500,500];
		_m setMarkerColor "ColorPink";
		_m setMarkerBrush "Border";
	} else {
		_m = createMarkerLocal [format["gunship%1",diag_tickTime],_dropPos];
		_m setMarkerShapeLocal "RECTANGLE";
		_m setMarkerSizeLocal [500,500];		
	};
	
	private _descriptor = [1,count(units _group),_difficulty,0,0,0,120,typeOf _aircraft,false];
	private _area = [_m,_descriptor,[_group],GMSAI_infantry,100000,1];
	GMSAI_activeStaticSpawns pushBack [_area,diag_tickTime];
	(leader _group) call GMSAI_fnc_nextWaypointAircraft;
} else {
	[_group,vehicle _group,_group getVariable["target"]] call GMSAI_fnc_dropReinforcements;	
	uisleep 5;
	[_group,"disengage"] call GMS_fnc_setGroupBehaviors;
	private _wp = [_group,0];
	_wp setWaypointCompletionRadius 10;
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointCombatMode "BLUE";
	_wp setWaypointSpeed "NORMAL";
	private _deletePos = (getPosATL _aircraft) getPos[3000,random(359)];
	_wp setWaypointPosition [_deletePos,0];
	_wp setWaypointTimeout [0,0.5,1];
	_wp setWaypointType "LOITER";
	_wp setWaypointStatements ["true","(vehicle _this) call GMS_fnc_destroyVehicleAndCrew;"];	
	_group setCurrentWaypoint _wp;
};


