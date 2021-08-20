/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_CalcImpactData
	Version: 		1.0
	Edited Date: 	18.08.2021
	
	Description:
		Calculate impact position of a projectile fired from an artillery unit
	
	Parameters:
		_projectile:	Object - projectile fired from artillery unit
	
	Returns:
		_pedictedImpactPos: Array - Position array [x, y, z]
*/

// NIC_IMP_DSP_fnc_CalcImpactData_dbg = {
params [["_projectile", [objNull]]];
if (isNull _projectile) exitWith {[]};

private _projectilePositionT0 = getPosWorld _projectile;								// position of projectile the moment is is fired
private _Vzero = (speed _projectile) / 3.6;												// calculate speed of projectile from km/h to m/s the moment is is fired
// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_IMP_DSP_fnc_CalcImpactData_dbg) _projectile: ", _projectile, ", _projectilePositionT0: ", _projectilePositionT0, ", _Vzero: ", _Vzero, " m/s"];
sleep NIC_IMP_DSP_wait;																				// wait short period for the round to move along it's trajectory
if (isNull _projectile || !alive _projectile) exitWith {[]};							// leave, if round no longer exists
private _projectilePosition2 = getPosWorld _projectile;									// position of projectile after waiting period
private _distance2D	= _projectilePositionT0 distance2D _projectilePosition2;			// calculate 2D distance (x axis value) between the two positions
private _heightDiff	= _projectilePosition2 #2 - _projectilePositionT0 #2;				// calculate height (y axis value) between the two positions; only working if round travels up!
private _elevAnkle	= atan (_heightDiff / _distance2D);									// calculate elevation angle of initial projectile flight trajectory
private _heading 	= _projectilePositionT0 getDir _projectilePosition2;				// calculate heading of projectile flight trajectory
// diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_CalcImpactData_dbg) _projectilePosition2: ", _projectilePosition2, ", _distance2D: ", _distance2D, ", _heightDiff: ", _heightDiff, ", _elevAnkle: ", _elevAnkle, ", _heading: ", _heading];
// diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_CalcImpactData_dbg) tan _elevAnkle: ", tan _elevAnkle, ", cos _elevAnkle: ", cos _elevAnkle];
private _heightImpactPosition = 0;														// we assume the height at impact position will be zero
private _i = 0;
private ["_range", "_pedictedImpactPos"];
while {_i < 5} do {
	_heightDiff = _projectilePositionT0 #2 - _heightImpactPosition;
	_range = _Vzero * cos _elevAnkle * (_Vzero * sin _elevAnkle + sqrt((_Vzero * sin _elevAnkle)^2 + 2 * 9.81 * _heightDiff)) / 9.81;			// calculate range of round 
	_pedictedImpactPos = _projectilePositionT0 getPos [_range, _heading];																		// calculate predicted impact position
	// diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_GetImpactData) _heightImpactPosition: ", _heightImpactPosition, ", _pedictedImpactPos: ", _pedictedImpactPos];
	if (getTerrainHeightASL _pedictedImpactPos < 0 || abs (_heightImpactPosition - getTerrainHeightASL _pedictedImpactPos) < 10) exitWith {};	// leave, if terrain height at predicted impact position is almost the same as the height predicted impact position was calculated with
	_heightImpactPosition = getTerrainHeightASL _pedictedImpactPos;																				// get terrain height position at calculated impact position
	_i = _i + 1;
};
_pedictedImpactPos set [2, 0];															// set impact height to zero above terrain level
_pedictedImpactPos
// };