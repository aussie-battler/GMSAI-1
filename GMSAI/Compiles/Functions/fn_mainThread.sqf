private _1sec = diag_tickTime;
private _5sec = diag_tickTime;
private _15sec = diag_tickTime;
private _60sec = diag_tickTime;

while {true} do
{
    uiSleep 1;
    if (diag_tickTime > _5sec) then
    {
        [] call GMSAI_fnc_monitorActiveAreas;             
        [] call GMSAI_fnc_monitorInactiveAreas;  
        [] call GMSAI_fnc_dynamicAIManager;
        if (GMSAI_debug > 0) then {[] call GMSAI_fnc_monitorGroupDebugMarkers};
       // call GMSAI_fnc_monitorParatroopSpawns;
        _5sec = diag_tickTime + 5;
    };
    if (diag_tickTime > _60sec) then
    {
       diag_log format["_mainThread: calling GMSAI_fnc_monitorAirPatrols at %1",diag_tickTime];
        [] call GMSAI_fnc_monitorAirPatrols;
        [] call GMSAI_fnc_monitorUAVPatrols;
        [] call GMSAI_fnc_monitorUGVPatrols;
        [] call GMSAI_fnc_monitorVehiclePatrols;
        [] call GMSAI_fnc_monitorEmptyVehicles;
        [] call GMSAI_fnc_monitorDeadUnits;
        //[] call GMSAI_fnc_monitorIActiveAreaMarkers;
        _60sec = diag_tickTime + 60;
        diag_log format[
            "GMSAI[timestamp %6]: %1 Infantry Groups | %2 Air Patrols | %3 Reinforcements | %4 Vehicle Patrols | %5 UAVs | ^5 UGVs", 
            //count GMSAI_infantryGroups,
            0,
            count GMSAI_airPatrols, 
            count GMSAI_paratroopGroups,
            count GMSAI_vehiclePatrols,
            count GMSAI_UAVPatrols,
            count GMSAI_UGVpatrols,
            diag_tickTime
        ];
    };
};