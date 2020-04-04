/*

*/
#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
diag_log format["[GMSAI] <BEGIN> _initializeUnitConfigurations.sqf at %1",diag_tickTime];

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

	#define chancePrimary 1
	#define chancePrimaryOptic 0.5
	#define chancePrimaryMuzzle 0.5
	#define chancePrimaryPointer 0.5
	#define chancePrimaryUnderbarrel 0.5

	#define chanceSecondary 1
	#define chanceSecondaryOptic 0.5
	#define chanceSeconaryPointer 0.5
	#define chanceSecondaryMuzzle 0.5
	#define chanceThrowable 0.4
	#define chanceBinoc 0.5
	#define chanceMedical 0.5
	#define chanceHeadgear 0.999
	#define chanceBinoc 0.5
	#define chanceGPS 0.2
	#define chanceUniform 1
	#define chanceVest 0.5
	#define chanceBackpack 1
	#define chanceFood 0.6
	#define chanceLoot 0.6
	#define chanceThroable 0.4


if (GMSAI_useCfgPricingForLoadouts && !(GMS_mod isEqualTo "default")) then
{
	diag_log "[GMSAI] _unitLoadoutExile: running dynamically determined loadouts";
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

	private _blacklistedGear = GMSAI_blacklistedInventoryItems + 
								GMSAI_blacklistedBackpacks + 
								GMSAI_blacklistedVests + 
								GMSAI_blacklistedUniforms +
								GMSAI_blacklistedPrimary + 
								GMSAI_blacklistedSecondary + 
								GMSAI_blackListedLauncher;

	//  [// max price to include, [items to exclude],[roots of classnames to exclude']]
	// This function builds dynamice loot from pricing and loot tables of epoch/exile 
	// It is quickest to exclude all blacklisted gear at this step rather than on the fly during spawning of AI.
	_gearBlue = [GMSAI_maxPricePerItem,_blacklistedGear,[/* blacklisted categories*/],[GMSAI_blacklistedMods]] call GMS_fnc_dynamicConfigs;
	
	// to illustrate the weapons lists returned ... Note that wpnLMG includes the MMGs
	_wpnPrimary = (_gearBlue select wpnAR) + (_gearBlue select wpnLMG) + (_gearBlue select wpnSMG) + (_gearBlue select wpnShotGun) + (_gearBlue select wpnSniper);
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
	//{diag_log format["[GMSAI] _unitLoadoutEpoch: GMSAI_gearBlue select %1 = %2",_forEachIndex,_x]} forEach GMSAI_gearBlue;
	//{diag_log format["[GMSAI] _unitLoadoutEpoch: GMSAI_gearRed select %1 = %2",_forEachIndex,_x]} forEach GMSAI_gearRed;
	//{diag_log format["[GMSAI] _unitLoadoutEpoch: GMSAI_gearGreen select %1 = %2",_forEachIndex,_x]} forEach GMSAI_gearGreen;		
	//{diag_log format["[GMSAI] _unitLoadoutEpoch: GMSAI_gearOrange select %1 = %2",_forEachIndex,_x]} forEach GMSAI_gearOrange;	
	diag_log "[GMSAI] CfgPricing-based loadouts used";
} else {
	diag_log "[GMSAI] Config-based loadouts used";
	// Lets remove any blacklisted items that might have crept in here by accident
	{
		_x = [_x,_blacklistedGear] call GMS_fnc_removeBlacklistedItems;
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
		[[_primary] call GMS_fnc_checkClassnames,
			GMSAI_chancePrimary,
			GMSAI_chanceOpticsPrimary,
			GMSAI_chanceMuzzlePrimary,
			GMSAI_chancePointerPrimary,
			GMSAI_chanceBipodPrimary
		],  //[]  primary weapons
		[[_handguns] call GMS_fnc_checkClassnames, GMSAI_chanceSecondary, 
			GMSAI_chanceOpticsSecondary, 
			GMSAI_chanceMuzzleSecondary, 
			GMSAI_chancePointerSecondary
		], 				// [] secondary weapons
		[[_throwableExplosives] call GMS_fnc_checkClassnames,GMSAI_chanceThrowable],																			 // [] throwables
		[[_headgear] call GMS_fnc_checkClassnames, GMSAI_chanceHeadgear],																					//[] headgear
		[[_uniforms] call GMS_fnc_checkClassnames, GMSAI_chanceUniform],																						// [] uniformItems
		[[_vests] call GMS_fnc_checkClassnames, GMSAI_chanceVest],																							//[] vests
		[[_backpacks] call GMS_fnc_checkClassnames, GMSAI_chanceBackpack],																					//[] backpacks
		[[_launchers] call GMS_fnc_checkClassnames, GMSAI_chanceLauncher],	
		[[_nvg] call GMS_fnc_checkClassnames,GMSAI_chanceNVG],																										//  launchers
		[[_binoculars] call GMS_fnc_checkClassnames,GMSAI_chanceBinoc],
		[[_food] call GMS_fnc_checkClassnames,GMSAI_chanceFood],
		[[_meds] call GMS_fnc_checkClassnames,GMSAI_chanceMedical],
		[[_partsAndValuables] call GMS_fnc_checkClassnames,GMSAI_chanceLoot]
	];
	
	GMSAI_gearRed = GMSAI_gearBlue;
	GMSAI_gearGreen = GMSAI_gearBlue;
	GMSAI_gearOrange = GMSAI_gearBlue;	
	{diag_log format["[GMSAI] _unitLoadoutEpoch: GMSAI_gearBlue select %1 = %2",_forEachIndex,_x]} forEach GMSAI_gearBlue;
	//{diag_log format["[GMSAI] _unitLoadoutEpoch: GMSAI_gearRed select %1 = %2",_forEachIndex,_x]} forEach GMSAI_gearRed;
	//{diag_log format["[GMSAI] _unitLoadoutEpoch: GMSAI_gearGreen select %1 = %2",_forEachIndex,_x]} forEach GMSAI_gearGreen;		
	//{diag_log format["[GMSAI] _unitLoadoutEpoch: GMSAI_gearOrange select %1 = %2",_forEachIndex,_x]} forEach GMSAI_gearOrange;	
	diag_log "[GMSAI] classnames checked and invalid names excluded";
};
diag_log format["[GMSAI] <END> _initializeUnitConfigurations.sqf at %1",diag_tickTime];
