/*
    GMSAI_fnc_monitorDynamicGroups 

    Purpose: provide a means to delete dynamicAI markers in the case that the player is dead and the group set to NULL which can not be handled by dynamicAIManager.

    Parameters: None 

    Returns: none 

	Copyright 2020 Ghostrider-GRG-

	Notes:     
*/
for "_i" from 1 to (count GMSAI_dynamicGroups) do
{
    if (_i > (count GMSAI_dynamicGroups)) exitWith {};
    private _g = GMSAI_dynamicGroups deleteAt 0;
   _g params["_group","_marker"];
    private _marker = "";
   
    if (_group isEqualTo grpNull) then
    {
         deleteMarker _marker;
    } else {
        if ({alive _x} count (units _group) == 0) then
        {
            deleteGroup _group;
            deleteMarker _marker;
        } else {
            GMSAI_dynamicGroups pushBack _g;
        };
    };
};