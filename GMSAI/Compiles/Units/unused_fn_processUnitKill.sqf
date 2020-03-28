params["_unit","_killer",["_isLegal",true]];
diag_log format["[GMSAI] processUnitKilled: _killer = %1  |  typeOf _killer = %2 | side killer = %3 | faction killer = %4",_killer, typeOf _killer,side _killer, faction _killer];
diag_log format["[GMSAI] processUnitKilled: Side _unit = %1 | side _killer = %2 | group = %3 | side group = %4",side _unit,side _killer, group _unit, side(group _unit)];

_unit setVariable ["GMSAI_deleteAt", (diag_tickTime) + GMSAI_bodyDeleteTimer];
private _group = group _unit;
//_group call GMS_fnc_stripDeadorNullUnits;

_group reveal[_killer,1];
diag_log format["[GMSAI] processUnitKilled: unit find nearest enemy position unit = %1",_unit findNearestEnemy (getPos _unit)];
if !(isLegal) exitWith {};
GMSAI_deadAI pushback _unit;
[_unit] joinSilent grpNull;
_group selectLeader (units _group select 0);
diag_log format["[GMSAI] processUnitKilled: combatMode _group = %1 | behavior leader = %2 | ",combatMode _group, behaviour (leader _group)];
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
	_group setVariable["GMSAI_target",_killer];
	if (_isLegal) then
	{
		_lastkill = _killer getVariable["GMSAI_timeOfLastkill",diag_tickTime];
		_killer setVariable["GMSAI_timeOfLastkill",diag_tickTime];
		_kills = (_killer getVariable["GMSAI_kills",0]) + 1;
		if ((diag_tickTime - _lastkill) < 240) then
		{
			_killer setVariable["GMSAI_kills",_kills];
		} else {
			_killer setVariable["GMSAI_kills",0];
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
//diag_log format["End of processUnitKill at %1",diag_tickTime];
/*
		things that have to happen are:

		Generic
		remove unit from group; delete group if empty.
		set unit cleanup timer
		1. determine if the killer is a player and if not don't send a reward.
		2. remove any NVG or launchers if appropriate.

		Infantry
		3. determine if the death is due to a runover situation that is prohibited; 
			If so, move the unit a bit and set damage to 0.
			else
				 message players with kill messages if appropriate
				send player respect, crypto or tabs if appropriate

		4. Aircraft 
			Test if aircraft crew all dead and if so set to lock to "UNLOCKED"

*/