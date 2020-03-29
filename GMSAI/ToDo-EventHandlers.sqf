TODO List:

	1. Unit MPKilled: 
		a. Runover checks: 
			if (vehicle _instigator != _instigator && driver(vehicle _instigator) == _instigator) then 
			{
				apply one of several runover strategies 
				i. revive the unit (A3AI style)
				ii. play a noise and send alert that this is bad form 
				iii. damage player, vehicle or both 
					Method 1. damage by random assignment of hitpoint damage)
					Method 2. by attaching explosive to the front of the vehicle 
				iv. strip AI of all gear 
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
		h. Message players with unit name, killstreak, bonus, changes to respect/reputation and tabs/crypto 
		i. diseminate information to nearby units of group and nearby groups: groups w/i 100 meters, vehicle groups w/i 300 meters
	
	2. Unit MPHit 
		Keep in mind that GMS deals with HandleDamage and heal mechanics 
		Things needed here are 
			~a system to provide information to nearby units of the group or groups about the location of the killer 
			~put the group into combat mode 


			








