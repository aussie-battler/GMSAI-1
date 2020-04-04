/*
	purpose: initilize GMSAI
	Copyright 2020 Ghostrider-GRG-
*/
#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
if (!(isServer) || hasInterface) exitWith {diag_log "[GMSAI] ERROR: GMSAI SHOULD NOT BE RUN ON A CLIENT PC";};
if (!isNil "GMSAI_Initialized") exitWith {diag_log "[GMSAI] 	ERROR: GMSAI AREADY LOADED";};
diag_log "[GMSAI] Initializing GMSAI";
[] call compileFinal preprocessFileLineNumbers "addons\GMSAI\init\GMSAI_init.sqf";
diag_log format["[GMSAI] Initialized at %1",diag_tickTime];
