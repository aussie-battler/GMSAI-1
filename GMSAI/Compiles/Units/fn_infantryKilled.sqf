/*
	GMSAI_fnc_infantryKilled 

	Purpose: execute GMSAI specific functions when a unit is killed 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPKilled 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes:
		TODO: needs reworking so it does not duplicate what GMS already does 
			that is put the body in the sceduler for deletion 
			add the body to a graveyard group 
			delete nvg and launcher if needed 
			put the group on combat status.
		TODO: need to think about what, if anything this should do, such as allerating other nearby groups. 
		Note that the standard GMS hit EH puts the group on alert and I believe increases that groups knowsAbout for the player	
*/

/*
		b. Killstreak Checks 
			Settings: 
				Share with GMS / GMSAI ?
				Killstreak Reward boosts: 
					increment per N kills:
					Value increased: respect/reputation, Tabs/crypto, both

				
		c. Distance Checks 
			Distance Reward Boosts:
				Increment per unit distance: (table or algorythm?)
				Value increased: respect/reputation, Tabs/crypto, both
			Notification styles (See messaging TODO, come back to this)

		d. Weapons Checks:
			Used secondary weapon?
				Value increased: respect/reputation, Tabs/crypto, both

		e. Set/Update killstreak value on player 
			Set to 0 if no kills wihthin a certain time 
			Increment otherwise 
			Use GMS_killstreak if common with GMS otherwise use GMSAI_killstreak. 

		f. calculate things needed for rewards 
			calculate distance 
			Check if weapon is secondary weapon 
			Check AI Name 
			Calculate bonus, changes to respect/reputation and tabs/crypto 

		g. Pull unit name 
			_name = name _unit; 

		h. Message players with unit name, killstreak, bonus, changes to respect/reputation and tabs/crypto 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_unit","_killer","_instigator"];

private _isLegal = if (vehicle _instigator != _instigator && driver(vehicle _instigator) == _instigator) then {false} else {true};
// putting the body in the cue for deletion and doing normal cleanup of NVG and launchers is handled by GMS
// Allerting nearby groups is handled by GMS according to a setting passed when the group was spawned.
// deal with road kill situations.
if !(isLegal) exitWith {
	[_unit,_killer,_instigator,GMSAI_runoverPenalties] call GMS_fnc_unitRunover;
	switch (GMSAI_modType) do 
	{
		case "epoch": {
			if (GMSAI_runoverMoneyPenalty) then 
			{
				[_killer,GMSAI_runoverTabsPenalty] call GMS_fnc_giveTakeCrypto;
				[GMSAI_runoverTabsPenalty] remoteExed["GMSAI_onRunoverMoneyRemovedPenalty",_killer];
			};
		};
		case "exile": {
				if (GMSAI_runoverMoneyPenalty != 0) then (
				{
					[_killer,GMSAI_runoverTabsPenalty] call GMS_fnc_giveTakeTabs;
					[GMSAI_runoverTabsPenalty] remoteExed["GMSAI_onRunoverMoneyRemovedPenalty",_killer];
				};

				if (GMSAI_runoverRespectPenalty 1= 0) then 
				{
					[_killer,GMSAI_runoverRespectPenalty] call GMS_fnc_giveTakeRespect;
					[GMSAI_runoverTabsPenalty] remoteExed["GMSAI_onRunoverTabRemovedPenalty",_killer];
				};
		};
		default {};
	};
};

/*
The constants used below are defined in \GMSAI\Configs\GMSAI_playerRewards.sqf
GMSAI_respectGainedPerKillBase = 5;
GMSAI_respectBonusForDistance = 5;
GMSAI_respectBonusForSecondaryKill = 25;
GMSAI_respectBonusForKillstreaks = 5; 

GMSAI_moneyGainedPerKillBase = 5;
GMSAI_moneyGainedPerKillForDistance = 5;
GMSAI_moneyGainedForSecondaryKill = 25;
GMSAI_moneyGainedForKillstreaks = 5; // per kill of the current killstreak 

GMSAI_killstreakTimeout = 300; // 5 min
GMSAI_distantIncrementForCalculatingBonus = 100;	
*/

//  calculate rewards: 
private _distance = _unit distance _killer;
private _killstreak = _killer getVariable ["killstreak",0];
private _weapon = currentWeapon _killer;
private _secondary = secondaryWeapon _killer;

/* RESPECT FIRST */ 
private = "_respectBonus";
if (toLower(GMSAI_modType) isEqualTo "exile") then 
{
	private _distanceBonus = if (_distance > 100) then {floor(round(_distance/100) * GMSAI_respectBonusForDistance = 5;)} else {0};
	private _killStreakBonus = if (_killstreak > 0) then {_killstreak * GMSAI_respectBonusForKillstreaks} else {0};
	private _pistolBonus = if (_weapon isEqualTo _secondary) then {GMSAI_respectBonusForSecondaryKill} else {0};
	_respectBonus = GMSAI_respectGainedPerKillBase + _distanceBonus + _pistolBonus;
	[_killer, _respectBonus] call GMS_fnc_giveTakeRespect;
};

// Now Money - its the same so just substitute 
private _distanceBonus = if (_distance > 100) then {floor(round(_distance/100)) * GMSAI_moneyGainedPerKillForDistance} else {0};
private _killStreakBonus = if (_killstreak > 0) then {_killstreak * GMSAI_moneyGainedForKillstreaks} else {0};
private _pistolBonus = if (_weapon isEqualTo _secondary) then {GMSAI_moneyGainedForSecondaryKill} else {0};
private _moneyBonus = GMSAI_moneyGainedPerKillBase + _distanceBonus + _pistolBonus;
switch(toLower(GMSAI_modType)) do 
{
	case "epoch": {[_killer,  _moneyBonus] call GMS_fnc_giveTakeCrypto;}
	case "exile": {[_killer,  _moneyBonus] call GMS_fnc_giveTakeTabs;};
};

/*
	Now send the player the good news that a mighty AI oppenet was felled.
	Info sent: 
	unit name 
	respect gained 
	mondy gained 
	killstreak
*/

[name _unit,_respectBonus,_moneyBonus,_killstreak] remoteExec["GMS_killNofication",_killer];
_killer setVariable["killstreak",_killstreak + 1];
[_unit,_killer,GMSAI_boostSkillsLastUnits] call GMSAI_fnc_boostOnNearbyUnitKilled;
/*  END */
