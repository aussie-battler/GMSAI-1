/*
	GMSAI_fnc_vehicleCrewKilled 

	Purpose: called when the MPKilled EH added by GMSAI is fired. 

	Parameters: per https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#MPKilled  

	Returns: none 
	
	Copyright 2020 by Ghostrider-GRG-
		
	Notes: 
		Just need to alert the crew and maybe any other units 
		and notify player and send any rewards. 

		body cleanup, removal of event handlers and disabling AI behaviors is handled by GMSCore
*/

//params["_unit","_killer","_instigator"];


