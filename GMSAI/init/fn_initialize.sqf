/*
	purpose: initilize GMSAI
	Copyright 2020 Ghostrider-GRG-
*/
if (!(isServer) || hasInterface) exitWith {diag_log "[GMSAI] ERROR: GMSAI SHOULD NOT BE RUN ON A CLIENT PC";};
if (!isNil "GMSAI_Initialized") exitWith {diag_log "[GMSAI] 	ERROR: GMSAI AREADY LOADED";};
[] call compileFinal preprocessFileLineNumbers "addons\GMSAI\init\GMSAI_init.sqf";
diag_log format["[GMSAI] Initialized at %1",diag_tickTime];
