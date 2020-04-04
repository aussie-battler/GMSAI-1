/*
	Unit loadouts for exile 
	Copyright 2020 Ghostrider-GRG-	
*/
#include "\addons\GMSAI\init\GMSAI_defines.hpp" 

diag_log format["[GMSAI] <BEGIN> GMSAI_unitLoadoutExile.sqf at %1",diag_tickTime];
/*
	CONFIGUREATIONS BEGIN HERE
*/
_GMSAI_moneyBlue = 30;
_GMSAI_moneyRed = 45;
_GMSAI_moneyGreen = 60;
_GMSAI_moneyOrange = 75;
/*   DO NOT TOUCH GMSAI_money  */
GMSAI_money = [_GMSAI_moneyBlue,_GMSAI_moneyRed,_GMSAI_moneyGreen,_GMSAI_moneyOrange];
/*******************************/

GMSAI_blackListedOptics = [];  //  Optics you do not want to allow
GMSAI_blackListedPointers = [];  // Pointers you do not want to allow
GMSAI_blackListedMuzzles = [];  // Muzzles you want to forbid
GMSAI_blacklistedInventoryItems = [];  // Inventory fron NVG to GPS or FAK you want to disallow
GMSAI_blacklistedBackpacks = [];
GMSAI_blacklistedVests = [];
GMSAI_blacklistedUniforms = [];
GMSAI_blacklistedHeadgear = [];
GMSAI_blacklistedPrimary = [];
GMSAI_blacklistedSecondary = [];
GMSAI_blackListedLauncher = [];
GMSAI_blackListedThrowables = [];
GMSAI_blacklistedMedical = [];
GMSAI_blacklistedFood = [];
GMSAI_blacklistedBinocs = [];
GMSAI_blacklistedNVG = [];

_headgear = ["H_Shemag_khk","H_Shemag_olive","H_Shemag_olive_hs","H_Shemag_tan","H_ShemagOpen_khk","H_ShemagOpen_tan","H_TurbanO_blk"];
_uniforms = ["U_IG_Guerilla1_1","U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla2_3","U_IG_Guerilla3_1","U_IG_Guerilla3_2"];
_vests = [
    "V_1_EPOCH","V_2_EPOCH","V_3_EPOCH","V_4_EPOCH","V_5_EPOCH","V_6_EPOCH","V_7_EPOCH","V_8_EPOCH","V_9_EPOCH","V_10_EPOCH","V_11_EPOCH","V_12_EPOCH","V_13_EPOCH","V_14_EPOCH","V_15_EPOCH","V_16_EPOCH","V_17_EPOCH","V_18_EPOCH","V_19_EPOCH","V_20_EPOCH",
    "V_21_EPOCH","V_22_EPOCH","V_23_EPOCH","V_24_EPOCH","V_25_EPOCH","V_26_EPOCH","V_27_EPOCH","V_28_EPOCH","V_29_EPOCH","V_30_EPOCH","V_31_EPOCH","V_32_EPOCH","V_33_EPOCH","V_34_EPOCH","V_35_EPOCH","V_36_EPOCH","V_37_EPOCH","V_38_EPOCH","V_39_EPOCH","V_40_EPOCH",
    // DLC Vests
    "V_PlateCarrierSpec_blk","V_PlateCarrierSpec_mtp","V_PlateCarrierGL_blk","V_PlateCarrierGL_mtp","V_PlateCarrierIAGL_oli"    
];
_backpacks = ["B_Carryall_ocamo","B_Carryall_oucamo","B_Carryall_mcamo","B_Carryall_oli","B_Carryall_khk","B_Carryall_cbr" ]; 
_primary = [
	// sniper
		"srifle_EBR_F","srifle_GM6_F","srifle_LRR_F","srifle_DMR_01_F",
	//  LMG
		"LMG_Mk200_F","LMG_Zafir_F",
	// 556
		"arifle_SDAR_F","arifle_TRG21_F","arifle_TRG20_F","arifle_TRG21_GL_F","arifle_Mk20_F","arifle_Mk20C_F","arifle_Mk20_GL_F","arifle_Mk20_plain_F","arifle_Mk20C_plain_F","arifle_Mk20_GL_plain_F","arifle_SDAR_F",
	// 650 
		"arifle_Katiba_F","arifle_Katiba_C_F","arifle_Katiba_GL_F","arifle_MXC_F","arifle_MX_F","arifle_MX_GL_F","arifle_MXM_F",
	// MMG					
		"MMG_01_hex_F","MMG_02_sand_F","MMG_01_tan_F","MMG_02_black_F","MMG_02_camo_F",
	// DLC Sniper		
		"srifle_DMR_02_camo_F","srifle_DMR_02_F","srifle_DMR_02_sniper_F","srifle_DMR_03_F","srifle_DMR_03_tan_F","srifle_DMR_04_F","srifle_DMR_04_Tan_F","srifle_DMR_05_blk_F","srifle_DMR_05_hex_F","srifle_DMR_05_tan_F","srifle_DMR_06_camo_F","srifle_DMR_06_olive_F",
	// Other DLC weapons
		"arifle_AK12_F","arifle_AK12_GL_F","arifle_AKM_F","arifle_AKM_FL_F","arifle_AKS_F","arifle_ARX_blk_F","arifle_ARX_ghex_F","arifle_ARX_hex_F","arifle_CTAR_blk_F","arifle_CTAR_hex_F",
		"arifle_CTAR_ghex_F","arifle_CTAR_GL_blk_F","arifle_CTARS_blk_F","arifle_CTARS_hex_F","arifle_CTARS_ghex_F","arifle_SPAR_01_blk_F","arifle_SPAR_01_khk_F","arifle_SPAR_01_snd_F",
		"arifle_SPAR_01_GL_blk_F","arifle_SPAR_01_GL_khk_F","arifle_SPAR_01_GL_snd_F","arifle_SPAR_02_blk_F","arifle_SPAR_02_khk_F","arifle_SPAR_02_snd_F","arifle_SPAR_03_blk_F",
		"arifle_SPAR_03_khk_F","arifle_SPAR_03_snd_F","arifle_MX_khk_F","arifle_MX_GL_khk_F","arifle_MXC_khk_F","arifle_MXM_khk_F"	
];
_handguns = ["hgun_PDW2000_F","hgun_ACPC2_F","hgun_Rook40_F","hgun_P07_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_02_F","hgun_Pistol_Signal_F"];
_throwableExplosives = ["HandGrenade","MiniGrenade","1Rnd_HE_Grenade_shell","3Rnd_HE_Grenade_shell"];
_drinks = ["Exile_Item_PlasticBottleCoffee","Exile_Item_PowerDrink","Exile_Item_PlasticBottleFreshWater","Exile_Item_Beer","Exile_Item_EnergyDrink","Exile_Item_MountainDupe"];
_food = [
	"Exile_Item_EMRE","Exile_Item_GloriousKnakworst","Exile_Item_Surstromming","Exile_Item_SausageGravy","Exile_Item_Catfood","Exile_Item_ChristmasTinner","Exile_Item_BBQSandwich","Exile_Item_Dogfood","Exile_Item_BeefParts",
	"Exile_Item_Cheathas","Exile_Item_Noodles","Exile_Item_SeedAstics","Exile_Item_Raisins","Exile_Item_Moobar","Exile_Item_InstantCoffee"
];
_meds = ["Exile_Item_InstaDoc","Exile_Item_Bandage","Exile_Item_Vishpirin"];
_partsAndValuables = [
	"Exile_Item_ExtensionCord","Exile_Item_JunkMetal","Exile_Item_LightBulb","Exile_Item_MetalBoard","Exile_Item_MetalPole","Exile_Item_MetalScrews","Exile_Item_Cement","Exile_Item_Sand",
	"Exile_Item_Matches","Exile_Item_CookingPot","Exile_Melee_Axe","Exile_Melee_SledgeHammmer","Exile_Item_Handsaw","Exile_Item_Pliers"
];
_items = [_drinks + _food + _meds + _partsAndValuables];
// available launchers include: ["launch_NLAW_F","launch_RPG32_F","launch_B_Titan_F","launch_I_Titan_F","launch_O_Titan_F","launch_B_Titan_short_F","launch_I_Titan_short_F","launch_O_Titan_short_F"];
_launchers = ["launch_RPG32_F"];
_nvg = ["NVGoggles","NVGoggles_INDEP","NVGoggles_OPFOR"];
_binoculars = ["Binocular","Rangefinder","Laserdesignator_02"];

/*
	CONFIGURATIONS END HERE
*/
/*
	please do not touch below this line 
*/

diag_log format["[GMSAI] <END> GMSAI_unitLoadoutExile.sqf at %1",diag_tickTime];
