/*
	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
for "_i" from 1 to (count GMSAI_groupDebugMarkers) do 
{
	if (_i > (count GMSAI_groupDebugMarkers)) exitWith {};
	private _m = GMSAI_groupDebugMarkers deleteAt 0;
	_m params["_group","_marker"];
	if ((isNull _group) || ({alive _x} count (units _group)) isEqualTo 0) then 
	{
		deleteMarker _marker;
	} else {
		_marker setMarkerPos (getPosATL(leader _group));
		GMSAI_groupDebugMarkers pushBack _m;
	};
};