/*
	GMSAI_fnc_initializeStaticSpawnsForLocations 

	Purpose: set up the static spawns at capitals, cities towns and others .

	Parameters: None 

	Returns: the list of locations for which static spawns were defined. 

	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
diag_log format["[GMSAI] _initializeStaticSpawnsForLocations: GMSAI_useStaticSpawns = %1",GMSAI_StaticSpawnsRandom];
if !(GMSAI_useStaticSpawns) exitWith 
{
	private _return = [];
	_return
};
_fn_createMarker = {
	params[
		"_location", // a location pulled from the map configs
		"_markerIndex", // a number used to ensure marker names are not duplicated
		"_markerColor"];
	private _m ="";
	if (GMSAI_debug > 1) then
	{	
		_m = createMarker [format["GMSAI_%1%2",(text _location),_markerIndex],(locationPosition _location)];
		_m setMarkerShape "RECTANGLE";
		_m setMarkerSize (size _location);
		_m setMarkerDir (direction _location);
		_m setMarkerText (text _location);
		_m setMarkerColor _markerColor;
	} else {
		_m = createMarkerLocal [format["GMSAI_%1%2",(text _location),_markerIndex],(locationPosition _location)];
		_m setMarkerShapeLocal "RECTANGLE";
		_m setMarkerSizeLocal (size _location);
		_m setMarkerDirLocal (direction _location);
	};
	_m  
};

private _markerIndex = 0;

_fn_setupLocationType = {
	params[
		"_locationType",
		"_aiDescriptor",
		"_markerColor"];
	//diag_log format["[GMSAI] _fn_setupLocationType: _this = %1",_this];
	private _configuredAreas = [];
	{	
		//diag_log format["village location %1 being evaluated",text _x];
		_marker = [_x,_markerIndex,_markerColor] call _fn_createMarker;
		_markerIndex = _markerIndex + 1;
		[_marker,_aiDescriptor] call GMSAI_fnc_addStaticSpawn;
		_configuredAreas pushBack _marker;
	} forEach nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), [_locationType], worldSize];	
	//diag_log format["[GMSAI] _fn_setupLocationType: %1 locations found searcing for %2",count _configuredAreas,_locationType];
	//diag_log format["_fn_setupLocationType: _configuredAreas = %1",_configuredAreas];
	_configuredAreas	
};

private _villages = ["NameVillage",GMSAI_staticVillageSettings,"COLORCIVILIAN"] call _fn_setupLocationType;
private _cites = ["NameCity",GMSAI_staticCitySettings,"COLORKHAKI"] call _fn_setupLocationType;
private _capitals = ["NameCityCapital",GMSAI_staticCapitalSettings,"COLORGREY"] call _fn_setupLocationType;
private _marine = ["NameMarine",GMSAI_staticMarineSettings,"COLORBLUE"] call _fn_setupLocationType;
private _other = ["NameLocal",GMSAI_staticOtherSettings,"COLORYELLOW"] call _fn_setupLocationType;
private _airport = ["Airport",GMSAI_staticOtherSettings,"COLORGREEN"] call _fn_setupLocationType;

private _return = _villages + _cites + _capitals + _marine + _other + _airport;
_return
