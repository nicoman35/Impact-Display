/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_GetImpactData
	Version: 		1.1
	Edited Date: 	10.09.2021
	
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

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
private _ammoData = (NIC_IMP_DSP_AMMO_LIST select {_x #0 == _magazine}) #0;
if (isNil{_ammoData}) exitWith {};  														// exit, if magazine projectile is fired from is not registered	in NIC_IMP_DSP_AMMO_LIST
private _impactData = [_projectile, true] call NIC_IMP_DSP_fnc_CalcImpactData;
if (count _impactData == 0) exitWith {};
private _pedictedImpactPosition = _impactData #0;											// calculated flight time of projectile
private _impactETA = _impactData #1;
private _impactETAcmd = floor (_unit getArtilleryETA [_pedictedImpactPosition, _magazine]);	// flight time of projectile given by command; sometimes not giving right flight time?!?
_pedictedImpactPosition set [2, 0];
private _special = _ammoData #3;
private _cursorData = _unit getVariable ["NIC_IMP_DSP_cursorData", []];
if (count _cursorData == 0) exitWith {};
private _memorizedImpactPosition = _cursorData #0;
private _cursorObject = _cursorData #1;
private _initialPositionObject = _cursorData #3;

if (_pedictedImpactPosition distance _memorizedImpactPosition > 300) exitWith {
	systemChat "Missfire! Target locked? Try again!";										 // if target object is 'locked', rounds will always fly around map position [0, 0], thus the round  is lost
}; 

if (_special == 1) then {
	_pedictedImpactPosition = _memorizedImpactPosition;
	if !(isNull	_cursorObject) then {
		_pedictedImpactPosition = _initialPositionObject;
	};  
};

[_unit, _magazine, _impactETA max _impactETAcmd, _ammo, _pedictedImpactPosition, _projectile, _special, _memorizedImpactPosition, _cursorObject, _initialPositionObject] spawn NIC_IMP_DSP_fnc_ProjectileMonitor;
