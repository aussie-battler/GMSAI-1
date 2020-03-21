#include "\addons\GMSAI\init\GMSAI_defines.hpp"

call compileFinal preprocessFileLineNumbers "addons\GMSAI\Variables\GMSAI_Variables.sqf";
call compileFinal preprocessFileLineNumbers "addons\GMSAI\Configs\GMSAI_configs.sqf";
//private _staticLocationSpawns = [] call GMSAI_fnc_initializeStaticSpawnsForLocations;
//[_staticLocationSpawns] call GMSAI_fnc_initializeRandomSpawnLocations;
[[] call GMSAI_fnc_initializeStaticSpawnsForLocations] call GMSAI_fnc_initializeRandomSpawnLocations;
//_staticLocationSpawns = nil;
call GMSAI_fnc_initializeAircraftPatrols;
call GMSAI_fnc_initializeUAVPatrols;
call GMSAI_fnc_initializeUGVPatrols;
call GMSAI_fnc_initializeVehiclePatrols;
[] spawn GMSAI_fnc_mainThread;
private _build = getText(configFile >> "GMSAAI_Build" >> "build");
private _buildDate = getText(configFile >> "GMSAAI_Build" >> "buildDate");
diag_log format["GMSAI Verion %1 Build Date %2 Initialized",_build,_buildDate];
GMSAI_Initialized = true;

