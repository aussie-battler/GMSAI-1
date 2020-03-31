/*
	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp"

[] call compileFinal preprocessFileLineNumbers "addons\GMSAI\Variables\GMSAI_Variables.sqf";
[] call compileFinal preprocessFileLineNumbers "addons\GMSAI\Configs\GMSAI_configs.sqf";

diag_log format["calling GMSAI_fnc_spawnUGVPatrol from GMSAI_init at %1",diag_tickTime];
_return = [0,"O_UGV_01_rcws_F",[0,0,0]] call GMSAI_fnc_spawnUGVPatrol;
diag_log format["GMSAI_fnc_spawnUGVPatrol returned %1",_return];

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

