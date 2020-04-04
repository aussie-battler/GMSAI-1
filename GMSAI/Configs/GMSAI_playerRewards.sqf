/*

*/
#include "\addons\GMSAI\init\GMSAI_defines.hpp" 
diag_log format["[GMSAI] <BEGIN> GMSAI_playerRewards.sqf at %1",diag_tickTime];

GMSAI_respectGainedPerKillBase = 5;
GMSAI_bonusRespectForDistance = 5;
GMSAI_bonusRespectForSecondaryKill = 25;

GMSAI_tabsGainedPerKillBase = 5;
GMSAI_tabsGainedPerKillForDistance = 5;
GMSA_bonusTabsForSecondaryKill = 25;

GMSAI_cryptoGainedPerKill = 5;
GMSAI_cryptoForDistance = 5; // per 100 M 
GMSAI_bonusCryptoForSecondaryKill = 25;

diag_log format["[GMSAI] <END> GMSAI_playerRewards.sqf at %1",diag_tickTime];