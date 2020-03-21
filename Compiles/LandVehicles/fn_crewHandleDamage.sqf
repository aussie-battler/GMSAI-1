
/*
	Scope Global 
	GMSAI_fnc_processCrewHandleDamage 
	Purpose: provide a means to negate damage acrued by collisions with the environment 
	Copyright 2020 by Ghostrider-GRG-
*/
params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
if (!(isPlayer _instigator) then 
{
	_unit setDamage 0;  
	_unit setHitPointDamage [_hitPoint, 0];
}