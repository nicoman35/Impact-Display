/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_GetImpactData
	Version: 		1.0
	Edited Date: 	31.08.2021
	
	Description:
		In case one of the unit types listed in the variable NIC_IMP_DSP_MONITORED_VEHICLES fires
		a round from a magazine registered in the variable NIC_IMP_DSP_AMMO_LIST, calculate impact
		parameters and start monitoring the projectile
	
	Parameters:
		_unit:			Object - vehicle, from which the round was shot
		_weapon:		String - Fired weapon
		_muzzle: 		String - Muzzle that was used
		_mode: 			String - Current mode of the fired weapon
		_ammo: 			String - Ammo used
		_magazine: 		String - magazine name which was used
		_projectile:	Object - projectile fired from artillery unit
	
	Returns:
		None
*/

// NIC_IMP_DSP_fnc_GetImpactData_dbg = {
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

if (isNil{(NIC_IMP_DSP_AMMO_LIST select {_x #0 == _magazine}) #0}) exitWith {};  		// exit, if magazine projectile is fired from is not registered	in NIC_IMP_DSP_AMMO_LIST
if (side _unit != side player) exitWith {};  											// exit, if artillery unit is not on same side as player
// private _pedictedImpactPos = [_projectile, true] call NIC_IMP_DSP_fnc_CalcImpactData;
private _impactData = [_projectile, true] call NIC_IMP_DSP_fnc_CalcImpactData;
if (count _impactData == 0) exitWith {};
private _pedictedImpactPos = _impactData #0;
private _impactETA = _impactData #1;													// calculated flight time of projectile
private _impactETAcmd = floor (_unit getArtilleryETA [_pedictedImpactPos, _magazine]);	// flight time of projectile given by command; sometimes not giving right flight time?!?
diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_GetImpactData) _impactETA: ", _impactETA, ", _impactETAcmd: ", _impactETAcmd];
_pedictedImpactPos set [2, 0];
[_unit, _magazine, _impactETA max _impactETAcmd, _ammo, _pedictedImpactPos, _projectile] spawn NIC_IMP_DSP_fnc_ProjectileMonitor;
// };
