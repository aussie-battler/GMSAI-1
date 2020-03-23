params["_unit","_killer"];
private _isLegal = true;
{format["nfantryKilled: typeOf _killer = %1  |  typeOf _killer = %2",typeOf _killer, typeOf _killer] call GMSAI_fnc_log;
if (isPlayer _killer && GMSAI_runoverProtection && !(vehicle _killer isEqualTo _killer)) then
{
	[format["infantryKilled: unit %1 runover by player %2 so negating damage acrued",_unit,_killer] call GMSAI_fnc_log;
	_unit setDamage 0;	
	_isLegal = false;
};
//diag_log format["[GMSAI] processUnitKilled: _killer = %1  |  typeOf _killer = %2 | side killer = %3 | faction killer = %4",_killer, typeOf _killer,side _killer, faction _killer];
//diag_log format["[GMSAI] processUnitKilled: Side _unit = %1 | side _killer = %2 | group = %3 | side group = %4",side _unit,side _killer, group _unit, side(group _unit)];

_unit setVariable ["deleteAt", (diag_tickTime) + GMSAI_bodyDeleteTimer];
private _group = group _unit;
//_group call GMS_fnc_stripDeadorNullUnits;

_group reveal[_killer,1];
//diag_log format["[GMSAI] processUnitKilled: unit find nearest enemy position unit = %1",_unit findNearestEnemy (getPos _unit)];
if !(isLegal) exitWith {};
GMSAI_deadAI pushback _unit;
[_unit] joinSilent grpNull;
_group selectLeader (units _group select 0);
//diag_log format["[GMSAI] processUnitKilled: combatMode _group = %1 | behavior leader = %2 | ",combatMode _group, behaviour (leader _group)];
//diag_log "processUnitKilled: line 7 reached";
if (count(units _group) < 1) then 
{
	deleteGroup _group;
};
//diag_log "processUnitKilled: line 12 reached";
[_unit,["MPKilled","MPHit"]] call GMS_fnc_removeMPEventHandlers;
//diag_log "processUnitKilled: line 16 reached";
[_unit,["Reloaded"]] call GMS_fnc_removeEventHandlers;
//diag_log "processUnitKilled: line 18 reached";
if (GMSAI_removeNVG) then
{
	[_unit] call GMS_fnc_removeNVG;
};
//diag_log "processUnitKilled: line 23 reached";
if (GMSAI_launcherCleanup) then
{
	[_unit] call GMS_fnc_removeLauncher;
};
//diag_log "processUnitKilled: line 28 reached";
if (isPlayer _killer) then 
{
	_group setVariable["target",_killer];
	if (_isLegal) then
	{
		_lastkill = _killer getVariable["timeOfLastkill",diag_tickTime];
		_killer setVariable["timeOfLastkill",diag_tickTime];
		_kills = (_killer getVariable["kills",0]) + 1;
		if ((diag_tickTime - _lastkill) < 240) then
		{
			_killer setVariable["kills",_kills];
		} else {
			_killer setVariable["kills",0];
		};
		//[_unit, ["Eject", vehicle _unit]] remoteExec ["action",(owner _unit)];
		if (GMSAI_useKillMessages) then
		{
			_weapon = currentWeapon _killer;
			_killstreakMsg = format[" %1X KILLSTREAK",_kills];
			private ["_message"];
			if (GMSAI_useKilledAIName) then
			{
				_message = format["%2: killed by %1 from %3m",name _killer,name _unit,round(_unit distance _killer)];
			}else{
				_message = format["%1 killed with %2 from %3 meters",name _killer,getText(configFile >> "CfgWeapons" >> _weapon >> "DisplayName"), round(_unit distance _killer)];
			};
			_message =_message + _killstreakMsg;
			[["aikilled",_message],allPlayers] call GMS_fnc_messageplayers;
		};
		[_killer,_unit distance _killer] call GMSAI_fnc_rewardPlayer;
	};
};