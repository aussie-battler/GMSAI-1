
/*
	Scope Global 
*/
params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
if !(isPlayer _instigator) then 
{
	_unit setDamage 0;  
	_unit setHitPointDamage [_hitPoint, 0];
};