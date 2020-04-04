

#include "addons\GMSAI\Configs\GMSAI_configs.sqf";
#include "addons\GMSAI\Configs\GMSAI_playerRewards.sqf";
if (toLower(GMS_modType) isEqualTo "epoch") then {[] call compileFinal preprocessFileLineNumbers "addons\GMSAI\Configs\GMSAI_unitLoadoutEpoch.sqf"};
if (toLower(GMS_modType) isEqualTo "exile") then {[] call compileFinal preprocessFileLineNumbers "addons\GMSAI\Configs\GMSAI_unitLoadoutExile.sqf"};
if (toLower(GMS_modType) isEqualTo "default") then {[] call compileFinal preprocessFileLineNumbers "addons\GMSAI\Configs\GMSAI_unitLoadoutDefault.sqf"};


/******************************************************************************************************************************************************** */
/*

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	DO NOT TOUCH ANYTHING BELOW THIS LINE 

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/

/******************************************************************************************************************************************************* */

/*
*** I kept this bit in for reference regarding the data structure for storing gear setups ***
*** See the mod-specific files for further information  ***

if (GMSAI_useConfigsBasedGearConfiguration) then
{
	// pull data from the CfgPricing or CfgArsenal configs - 
	// needs work to load the food, beverage, toos, and medical items
	// For now uses the defaults in the mod-specific configs
	private _gear = call GMS_fnc_dynamicConfigs;
	#define GMS_primary 0
	#define GMS_secondary 1
	#define GMS_throwable 2
	#define GMS_headgear 3
	#define GMS_uniforms 4
	#define GMS_vests 5
	#define GMS_backpacks 6
	#define GMS_items 7
	#define GMS_launchers 8;

	{
		private _gearArray = _x;
		_gearArray set[GMS_primary, _gear select GMS_primary];
		_gearArray set[GMS_secondary, _gear select GMS_secondary];
		_gearArray set[GMS_headgear, _gear select GMS_headgear];
		_gearArray set[GMS_uniforms, _gear select GMS_uniforms];
		_gearArray set[GMS_vests, _gear select GMS_vests];
		_gearArray set[GMS_backpacks, _gear select GMS_backpacks];
		//_items = [_gear select GMS_items select 0,_gear select GMS_items select 1;
		//_gearArray set[GMS_items,_items];
	} forEach [GMSAI_gearBlue,GMSAI_gearRed,GMSAI_gearGreen,GMSAI_gearOrange];
};
*/
/*
GMSAI_gearBlue = [
	[], // primary weapons
	[], // secondary weapons
	[], // throwables
	[], // headgear
	[], // uniformItems
	[], // vestItems
	[], // backpacks
	[], // items and equipment
	[] // launchers
];
*/
/****************************************************************************************************************************************************** */

GMSAI_unitDifficulty = [GMSAI_skillBlue, GMSAI_skillRed, GMSAI_skillGreen, GMSAI_skillOrange];
GMSAI_money = [_GMSAI_moneyBlue,_GMSAI_moneyRed,_GMSAI_moneyGreen,_GMSAI_moneyOrange];
GMSAI_unitLoadouts = [GMSAI_gearBlue, GMSAI_gearRed, GMSAI_gearGreen, GMSAI_gearOrange];
GMSAI_staticVillageSettings = [GMSAI_staticCityGroups,GMSAI_staticVillageUnitsPerGroup,GMSAI_staticVillageUnitsDifficulty,GMSAI_ChanceStaticCityGroups,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticCitySettings = [GMSAI_staticCityGroups,GMSAI_staticCityUnitsPerGroup,GMSAI_staticCityUnitsDifficulty,GMSAI_ChanceStaticCityGroups,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticCapitalSettings = [GMSAI_staticCapitalGroups,GMSAI_staticCapitalUnitsPerGroup,GMSAI_staticCapitalUnitsDifficulty,GMSAI_ChanceCapitalGroups,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticMarineSettings = [GMSAI_staticMarineGroups,GMSAI_staticMarineUnitsPerGroup,GMSAI_staticMarineUnitsDifficulty,GMSAI_ChanceStaticMarineUnits,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticOtherSettings = [GMSAI_staticOtherGroups,GMSAI_staticOtherUnitsPerGroup,GMSAI_staticOtherUnitsDifficulty,GMSAI_ChanceStaticOtherGroups,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticRandomSettings = [GMSAI_staticRandomGroups,GMSAI_staticRandomUnits,GMSAI_staticRandomUnitsDifficulty,GMSAI_staticRandomChance,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_dynamicSettings = [GMSAI_dynamicRandomGroups,GMSAI_dynamicRandomUnits,GMSAI_dynamicUnitsDifficulty,GMSAI_dynamicRandomChance,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];

/*
	VERIFY CLASSNAMES FOR PLANES, HELIS, UAV, UGV, TANKS, APCS, TRUCKS, CARS, ETC
*/
{
	private _array = _x;
	if (count (_array select 0) == 1) then 
	{
		_x = [_array] call GMS_fnc_checkClassNamesArray;
	};
	if (count (_array select 0) == 1) then 
	{
		_x = [_array] call GMS_fnc_checkClassNamesWeightArray;
	};
} forEach [
	GMSAI_patrolVehicles,
	GMSAI_aircraftTypes,
	GMSAI_paratroopAircraftTypes,
	GMSAI_UAVTypes,
	GMSAI_UAVTypes
	];