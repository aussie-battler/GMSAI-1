/*
	Copyright 2020 Ghostrider-GRG-
*/

#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
params["_group",["_vehicle","Man"]];
private _m = createMarker[format["GMSAI_debugMarker%1",random(1000000)],getPosATL(leader _group)];
_m setMarkerType "mil_triangle";
_m setMarkerColor "COLORRED";
_m setMarkerPos getPosATL(leader _group);
_m setMarkerText format["%1:%2:%3",_vehicle,_group,{alive _x} count (units _group)];
GMSAI_groupDebugMarkers pushBack [_group,_m];

