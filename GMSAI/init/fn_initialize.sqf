/*
	purpose: initilize GMSAI
	Copyright 2020 Ghostrider-GRG-
*/

if (!(isServer) || hasInterface) exitWith {diag_log "[GMSAI] ERROR: GMSAI SHOULD NOT BE RUN ON A CLIENT PC";};
if (!isNil "GMSAI_Initialized") exitWith {diag_log "[GMSAI] 	ERROR: GMSAI AREADY LOADED";};
while {isNil "GMS_modType"} do 
{
	uiSleep 5;
	diag_log format["[GMSAI] fn_initialize: waiting for GMS_modType to be initialized at %1",diag_tickTime];
};

// Defines that are used for configuration of units and other things 
#include "\addons\GMSAI\init\GMSAI_defines.hpp"

// variables in which lists of areas, groups, etc are stored 
#include "\addons\GMSAI\Variables\GMSAI_Variables.sqf";

// private variables used to temprarily store unit configs so that their scope is set to anywhere within this script 
#include "\addons\GMSAI\init\GMSAI_defineUnitConfigurationPrivateVars.sqf"

// configs for static and dynamic patrols, as well as vehicle, air, UGV and UAV patrols. 
#include "\addons\GMSAI\Configs\GMSAI_configs.sqf";

// configs for units based on the type of mod or use a default setting if no mod specified.
if (toLower(GMS_modType) isEqualTo "epoch") then 
{
	#include "\addons\GMSAI\Configs\GMSAI_unitLoadoutEpoch.sqf";
};
if (toLower(GMS_modType) isEqualTo "exile") then 
{
	#include "\addons\GMSAI\Configs\GMSAI_unitLoadoutExile.sqf";
};
if (toLower(GMS_modType) isEqualTo "default") then {
	#include "\addons\GMSAI\Configs\GMSAI_unitLoadoutDefault.sqf";
};

//  Load the player rewards configurations
#include "\addons\GMSAI\Configs\GMSAI_playerRewards.sqf";

/*
	Configure the more complex arrays used to describe the configuration parameters 
	by GMSAI once it is running 
*/
private _blacklistedGear = [];
{
	_blacklistedGear append _x;
} forEach [
	GMSAI_blackListedOptics,
	GMSAI_blackListedPointers,
	GMSAI_blackListedMuzzles,
	GMSAI_blacklistedBackpacks,
	GMSAI_blacklistedVests,
	GMSAI_blacklistedUniforms,
	GMSAI_blacklistedHeadgear,
	GMSAI_blacklistedPrimary,
	GMSAI_blacklistedSecondary,
	GMSAI_blackListedLauncher,
	GMSAI_blackListedThrowables,
	GMSAI_blacklistedMedical,
	GMSAI_blacklistedFood,
	GMSAI_blacklistedBinocs,
	GMSAI_blacklistedNVG
];

if (GMSAI_useCfgPricingForLoadouts && !(GMS_modType isEqualTo "default")) then
{
	//diag_log "[GMSAI] _unitLoadoutExile: running dynamically determined loadouts";
	/*
	To help out in sorting out how to parse this I included some //#defines
	GMS_fnc_dynamicConfigs returns data in arrays in the following order
	_wpnAR,			// 0
	_wpnLMG,		// 1
	_wpnSMG,		// 2
	_wpnShotGun,	// 3
	_wpnSniper,		// 4
	_wpnHandGun,	// 5
	_wpnLauncher,	// 6
	_wpnThrow,		// 7
	_wpnOptics,		// 8
	_wpnMuzzles,	// 9
	_wpnPointers,	// 10
	_wpnUnderbarrel, // 11
	_binocular,		// 12
	_gps,			// 13
	_nvg,			// 14
	_map,			// 15
	_medKit,		// 16
	_mineDetector,	// 17
	_radio,			// 18
	_toolKit,		// 19
	_firstAidKit,	// 20
	_UAVTerminal,	// 21
	_watch,			// 22
	_glasses,		// 23
	_headgear,		// 24
	_uniforms,		// 25
	_vests,			// 26
	_backpacks,		// 27
	_foodAndDrinks,	// 28  {mod-specific food and drinks}
	_lootItems		// 29 (mod-specific loot itmes such as car parts, raw materials, defib and the like)
	*/
	/*
	#define wpnAR 0
	#define wpnLMG 1
	#define wpnSMG 2
	#define wpnShotGun 3
	#define wpnSniper 4
	#define wpnHandGun 5
	#define wpnLauncher 6
	#define wpnThrow 7
	#define wpnOptics 8
	#define wpnMuzzles 9
	#define pointers 10
	#define wpnUnderbarrel 11
	#define BinocularItems 12
	#define  GpsItems 13
	#define NvgItems 14
	#define MapItems 15
	#define MedicalItems 16
	#define MineDetectors 17
	#define Radios 18
	#define ToolKits 19
	#define FirstAidKits 20
	#define UAVTerminals 21
	#define watches 22
	#define glasses 23
	#define headgearItems 24
	#define uniforms 25
	#define vests 26
	#define backpacks 27
	#define foodAndDrinks 28
	#define lootItems 29
*/
	//diag_log format["[GMSAI] _initializeUnitConfigs (134): typeName _blacklistedGear = %1 | count _blacklistedGear = %2",typeName _blacklistedGear,count _blacklistedGear];


	/*
	The gear loading routine expects gear to be arranged in the following orderGetIn
	#define GMS_primary 0
	#define GMS_secondary 1
	#define GMS_throwable 2
	#define GMS_headgear 3
	#define GMS_uniforms 4
	#define GMS_vests 5
	#define GMS_backpacks 6
	#define GMS_launchers 7
	#define GMS_nvg 8
	#define GMS_binocs 9
	#define GMS_foodAndDrinks 10
	#define GMS_medical 11
	#define GMS_loot 12

	Note that there is a chance for each category and
	for primary weapons and handguns the chance of each category of attachment is specified.
	The chance of things being added is customizable for each AI difficulty
	Certain items could be excluded just by omitting them or setting the chance to 0, or by doing an array subtraction of some sort to remove those items you do not wish to have in the Ai for that diffiuclty level.
	*/

	/*
	  [// max price to include, [items to exclude],[roots of classnames to exclude']]
	 This function builds dynamice loot from pricing and loot tables of epoch/exile 
	 It is quickest to exclude all blacklisted gear at this step rather than on the fly during spawning of AI.

	 Note that the defined constants used here are defined in \init\GMSAI_defines.hpp
	*/
	private _gearBlue = [GMSAI_maxPricePerItem,_blacklistedGear,[/* blacklisted categories*/],[GMSAI_blacklistedMods]] call GMS_fnc_dynamicConfigs;
	
	// to illustrate the weapons lists returned ... Note that wpnLMG includes the MMGs
	private _wpnPrimary = (_gearBlue select wpnAR) + (_gearBlue select wpnLMG) + (_gearBlue select wpnSMG) + (_gearBlue select wpnShotGun) + (_gearBlue select wpnSniper);	
	GMSAI_gearBlue = [
		[_wpnPrimary,GMSAI_chancePrimary,
			GMSAI_chanceOpticsPrimary,
			GMSAI_chanceMuzzlePrimary,
			GMSAI_chancePointerPrimary,
			GMSAI_blacklistedPrimary
		], // Just adding together all the subclasses of primary weaponss
		[_gearBlue select wpnHandGun, 
			GMSAI_chanceSecondary, 
			GMSAI_chanceOpticsSecondary, 
			GMSAI_chanceMuzzleSecondary, 
			GMSAI_chancePointerSecondary,
			GMSAI_blacklistedSecondary
		],
		[_gearBlue select wpnThrow, GMSAI_chanceThrowable,GMSAI_blackListedThrowables],
		[_gearBlue select headgearItems, GMSAI_chanceHeadgear,GMSAI_blacklistedHeadgear],
		[_gearBlue select uniforms, GMSAI_chanceUniform,GMSAI_blacklistedUniforms],
		[_gearBlue select vests, GMSAI_chanceVest,GMSAI_blacklistedVests],
		[_gearBlue select backpacks, GMSAI_chanceBackpack,GMSAI_blacklistedBackpacks],
		[_gearBlue select wpnLauncher, GMSAI_chanceLauncher,GMSAI_blackListedLauncher],  // this is determined elsewhere for GMSAI
		[_gearBlue select NvgItems, GMSAI_chanceNVG,GMSAI_blacklistedNVG],  // this is determined elsewhere for GMSAI
		[_gearBlue select BinocularItems,GMSAI_chanceBinoc,GMSAI_blacklistedBinocs],
		[_gearBlue select foodAndDrinks, GMSAI_chanceFood,GMSAI_blacklistedFood],
		[_gearBlue select MedicalItems, GMSAI_chanceMedical,GMSAI_blacklistedMedical],
		[_gearBlue select lootItems, GMSAI_chanceLoot,GMSAI_blacklistedInventoryItems]
	];

	GMSAI_gearRed = GMSAI_gearBlue;
	GMSAI_gearGreen = GMSAI_gearBlue;
	GMSAI_gearOrange = GMSAI_gearBlue;	
	
	diag_log "[GMSAI] CfgPricing-based loadouts used";
} else {
	diag_log "[GMSAI] Config-based loadouts used";

	// Lets remove any blacklisted items that might have crept in here by accident
	//diag_log format["fn_initialize: _blacklistedGear = %1",_blacklistedGear];
	private _gearNames = [
		'_primary',
		'_handguns',
		'_throwableExplosives',
		'_headgear',
		'_uniforms',
		'_vests',
		'_backpacks',
		'_launchers',
		'_nvg',
		'_binoculars',
		'_food',
		'_meds',
		'_partsAndValuables'
	];
	{
		_x = [_x,_blacklistedGear] call GMS_fnc_removeBlacklistedItems;
		_x = [_x] call GMS_fnc_checkClassnamesArray;
	} forEach [
		_primary,
		_handguns,
		_throwableExplosives,
		_headgear,
		_uniforms,
		_vests,
		_backpacks,
		_launchers,
		_nvg,
		_binoculars,
		_food,
		_meds,
		_partsAndValuables
	];

	GMSAI_gearBlue = [
		[_primary,
			GMSAI_chancePrimary,
			GMSAI_chanceOpticsPrimary,
			GMSAI_chanceMuzzlePrimary,
			GMSAI_chancePointerPrimary,
			GMSAI_chanceBipodPrimary
		],  //[]  primary weapons
		[_handguns, 
			GMSAI_chanceSecondary, 
			GMSAI_chanceOpticsSecondary, 
			GMSAI_chanceMuzzleSecondary, 
			GMSAI_chancePointerSecondary
		], 	// [] secondary weapons
		[_throwableExplosives,GMSAI_chanceThrowable],																			 // [] throwables
		[_headgear, GMSAI_chanceHeadgear],																					//[] headgear
		[_uniforms, GMSAI_chanceUniform],																						// [] uniformItems
		[_vests, GMSAI_chanceVest],																							//[] vests
		[_backpacks, GMSAI_chanceBackpack],																					//[] backpacks
		[_launchers, GMSAI_chanceLauncher],	
		[_nvg, GMSAI_chanceNVG],																										//  launchers
		[_binoculars, GMSAI_chanceBinoc],
		[_food, GMSAI_chanceFood],
		[_meds, GMSAI_chanceMedical],
		[_partsAndValuables, GMSAI_chanceLoot]
	];
	
	GMSAI_gearRed = GMSAI_gearBlue;
	GMSAI_gearGreen = GMSAI_gearBlue;
	GMSAI_gearOrange = GMSAI_gearBlue;	
	diag_log "[GMSAI] classnames checked and invalid names excluded";
};

{
	private _array = _x;
	if (count (_array select 0) == 1) then 
	{
		_x = [_array] call GMS_fnc_checkClassNamesArray;
	};
	if (count (_array select 0) == 1) then 
	{
		_x = [_array] call GMS_fnc_checkClassNamesArray;
	};
} forEach [GMSAI_patrolVehicles,GMSAI_paratroopAircraftTypes,GMSAI_UAVTypes,GMSAI_UAVTypes];

GMSAI_unitDifficulty = [GMSAI_skillBlue, GMSAI_skillRed, GMSAI_skillGreen, GMSAI_skillOrange];
GMSAI_unitLoadouts = [GMSAI_gearBlue, GMSAI_gearRed, GMSAI_gearGreen, GMSAI_gearOrange];
GMSAI_staticVillageSettings = [GMSAI_staticCityGroups,GMSAI_staticVillageUnitsPerGroup,GMSAI_staticVillageUnitsDifficulty,GMSAI_ChanceStaticCityGroups,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticCitySettings = [GMSAI_staticCityGroups,GMSAI_staticCityUnitsPerGroup,GMSAI_staticCityUnitsDifficulty,GMSAI_ChanceStaticCityGroups,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticCapitalSettings = [GMSAI_staticCapitalGroups,GMSAI_staticCapitalUnitsPerGroup,GMSAI_staticCapitalUnitsDifficulty,GMSAI_ChanceCapitalGroups,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticMarineSettings = [GMSAI_staticMarineGroups,GMSAI_staticMarineUnitsPerGroup,GMSAI_staticMarineUnitsDifficulty,GMSAI_ChanceStaticMarineUnits,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticOtherSettings = [GMSAI_staticOtherGroups,GMSAI_staticOtherUnitsPerGroup,GMSAI_staticOtherUnitsDifficulty,GMSAI_ChanceStaticOtherGroups,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_staticRandomSettings = [GMSAI_staticRandomGroups,GMSAI_staticRandomUnits,GMSAI_staticRandomUnitsDifficulty,GMSAI_staticRandomChance,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];
GMSAI_dynamicSettings = [GMSAI_dynamicRandomGroups,GMSAI_dynamicRandomUnits,GMSAI_dynamicUnitsDifficulty,GMSAI_dynamicRandomChance,GMSAI_staticRespawns, GMSAI_staticRespawnTime, GMSAI_staticDespawnTime,"Man"];

diag_log format["[GMSAI] Initializing Static and Vehicle Spawns at %1",diag_tickTime];
[[] call GMSAI_fnc_initializeStaticSpawnsForLocations] call GMSAI_fnc_initializeRandomSpawnLocations;
[] call GMSAI_fnc_initializeAircraftPatrols;
[] call GMSAI_fnc_initializeUAVPatrols;
[] call GMSAI_fnc_initializeUGVPatrols;
[] call GMSAI_fnc_initializeVehiclePatrols;
[] spawn GMSAI_fnc_mainThread;

private _build = getText(configFile >> "GMSAAI_Build" >> "build");
private _buildDate = getText(configFile >> "GMSAAI_Build" >> "buildDate");

GMSAI_Initialized = true;

[] call compileFinal preprocessFileLineNumbers "\addons\GMSAI\Configs\GMSAI_custom.sqf";
diag_log format["GMSAI Verion %1 Build Date %2 Initialized at %3",_build,_buildDate,diag_tickTime];