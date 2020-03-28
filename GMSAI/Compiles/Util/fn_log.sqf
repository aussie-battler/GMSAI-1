/*
	GMSAI_fnc_log 

	Purpose: provide mod specific loging 

	Parameters:	
		_msg, the message to log 
		_type, an optional code that can be warning, error or "" if included 

	Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes: 
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_msg",["_type",""]];
switch (toLower _type) do 
{
	case "warning": {_msg = format["[GMSAI] <WARNING>  %1",_msg]};
	case "error": {_msg = format["[GSAI] <ERRR>  %1",_msg]};
	default {_msg = format["[GMSAI]  %1",_msg]};
};
diag_log _msg;
