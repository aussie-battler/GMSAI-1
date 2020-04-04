/*
	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp"
diag_log format["{GMSAI} <BEGIN> GMSAI_init.sqf at %1",diag_tickTime];
diag_log format["[GMSAI] GMSAI_init.sqf:  Loading Variables at %1",diag_tickTime];
[] call compileFinal preprocessFileLineNumbers "addons\GMSAI\Variables\GMSAI_Variables.sqf";
diag_log format["[GMSAI] GMSAI_init.sqf:  Loading Configuration at %1",diag_tickTime];

#include "\addons\GMSAI\init\fn_initializeConfiguration.sqf";

while{isNil "GMSAI_unitLoadoutDefined"} do 
{ 
	uisleep 5; 
	diag_log format["GMSAI] waiting for initialization of GMSAI_dynamicSettings at %1",diag_tickTime];
};

diag_log format["[GMSAI] Initializing Static and Vehicle Spawns at %1",diag_tickTime];
[[] call GMSAI_fnc_initializeStaticSpawnsForLocations] call GMSAI_fnc_initializeRandomSpawnLocations;
[] call GMSAI_fnc_initializeAircraftPatrols;
[] call GMSAI_fnc_initializeUAVPatrols;
[] call GMSAI_fnc_initializeUGVPatrols;
[] call GMSAI_fnc_initializeVehiclePatrols;
[] spawn GMSAI_fnc_mainThread;

private _build = getText(configFile >> "GMSAAI_Build" >> "build");
private _buildDate = getText(configFile >> "GMSAAI_Build" >> "buildDate");
diag_log format["GMSAI Verion %1 Build Date %2 Initialized",_build,_buildDate];
GMSAI_Initialized = true;
diag_log format["{GMSAI} <BEGIN> GMSAI_init.sqf at %1",diag_tickTime];

