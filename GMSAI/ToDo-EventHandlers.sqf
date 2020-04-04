TODO List:

	1. Unit MPKilled: 
		a. Runover checks: 
			if (vehicle _instigator != _instigator && driver(vehicle _instigator) == _instigator) then 
			{
				apply one of several runover strategies 
				i. revive the unit (A3AI style)
					GMS_fnc_healUnit
					{
						params["_unit"];
						[_unit setDamage 0;
						private _hp = getAllHitPointsDamage _unit;
						private _hpNames = _hp select 0;
						private _hpValues = _hp select 2;
						{
							_unit setHitPointDamage [_x, _hpValues select _forEachIndex];
						} forEach _hpnames;
					};

				ii. play a noise and send alert that this is bad form 
					[illegalUnitRunover /* the code*/, ""] call GMS_fnc_messagePlayers;
					-> could add a tag here so if the person is a repeat offender then damage is also applied. 

				iii. damage player, vehicle or both 
					Method 1. damage by random assignment of hitpoint damage)
					GMS_fnc_randomHitpointDamage 
					{

						params["_veh",["_hpDamage",0.6],["_noHpDamaged",4]];
						private _hp = getAllHitPointsDamage _veh;
						private _hpNames = _hp select 0;
						private _hpValues = _hp select 2;						
						for "_i" from 0 to ([_noHpDamaged call GMS_fnc_getNumberFromRange) do 
						{
							_hp = random(count _hoValues);
							_veh setHitPointDamage [(_hpNames select _hp), (_hpValues select _hp) + [_hpDamage] call GMS_fnc_selectNumberFromRange];
						};
					};

					Method 2. by attaching explosive to the front of the vehicle 

					GMS_fnc_detonateExplosiveOnObject 
					{
						params["_obj",["_explosive","MiniGrenade"]];
						private _bomb = createVehicle[_explosive,[0,0,0]];
						private _hpNames = (getAllHitPointsDamage _obj) select 1;
						_obj attachTo[_bomb,[0,1,0],_hpNames select (round(random(count _hpNames)))];
					};
				iv. strip AI of all gear 

					[_unit] call GMS_fnc_unitRemoveAllGear;
			};

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
		
		i. diseminate information to nearby units of group and nearby groups: groups w/i 100 meters, vehicle groups w/i 300 meters
			[_unit,_killer,_alertDefaultValue] call GMS_fnc_allertGroup;
				params["_unit","_target",["_alertValue",0.2]]
				{
					_x reveal[_target,_alertValue];
				}forEach (units (group _unit));

			[_unit,_killer,_alertDistance,_alertDefaultValue] call GMS_fnc_allertNearestGroup;
				params ["_unit","_killer","_alertDistance","_alertDefaultValue"]; 			
				private _ng = group(nearestObject[getPosATL _unit,GMS_unitType];
				if (side _ng isEqualTo GMSAI_side) then 
				{
					_x reveal["_target",_alertValue];
				} forEach (units _ng);

			[_unit,_killer,_alertDistance,_alertDefaultValue] call GMS_fnc_allertNearestInfantryGroup;
				params ["_unit","_killer","_alertDistance","_alertDefaultValue"]; 			
				private _nai = nearestObjects[getPosATL _unit, [GMS_unitType],_alerDistance] select {(vehicle _x isEqualTo _x)};  // on foot only 
				{
					_x reveal[_target,_alertValue];
				} forEach (units (group (_nai select 0)));

			[_unit,_killer,_alertDistance,_alertDefaultValue] call GMS_fnc_allertNearestVehicleGroup;
				params ["_unit","_killer","_alertDistance","_alertDefaultValue"]; 
				private _nai = nearestObjects[getPosATL _unit, [GMS_unitType],_alerDistance] select {(vehicle _x != _x)};  // on foot only 
				{
					_x reveal[_target,_alertValue];
				} forEach (units (group (_nai select 0)));

	2. Unit MPHit 
		Keep in mind that GMS deals with HandleDamage and heal mechanics 
		Things needed here are 
			~a system to provide information to nearby units of the group or groups about the location of the killer 
				At present, this is done for the group; 
				could add a chance that the nearest vehicle or group is also allerted with nearestObjects[getPosATL (leader _group),["Car","Tank","Air"]] select {side(group(crew _x_) select 0)} and alert that vehicles group.
					->write a little function in GMS to do this. 
					GMS_fnc_findNearestAIVehicle
						params["_pos","_chance"];

			~put the group into combat mode 


			








