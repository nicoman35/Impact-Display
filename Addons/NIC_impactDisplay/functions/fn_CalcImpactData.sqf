/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_CalcImpactData
	Version: 		1.0
	Edited Date: 	30.09.2021
	
	Description:
		Calculate impact position of a projectile fired from an artillery unit
	
	Parameters:
		_projectile:	Object - projectile fired from artillery unit
		_eta:			Bool - calculate projectile eta
	
	Returns:
		Array [_pedictedImpactPos: Array - Position array [x, y, z], _eta]
*/

params [["_projectile", [objNull]], ["_eta", false]];
if (isNull _projectile) exitWith {[]};

private _projectilePositionT0 = getPosWorld _projectile;								// position of projectile the moment is is fired
private _Vzero = (speed _projectile) / 3.6;												// calculate speed of projectile from km/h to m/s the moment is is fired
// private _Vzero = velocityModelSpace _projectile #1;

// sleep NIC_IMP_DSP_wait;																	// wait short period for the round to move along it's trajectory
sleep 0.1;																				// wait short period for the round to move along it's trajectory
if (isNull _projectile || !alive _projectile) exitWith {[]};							// leave, if round no longer exists
private _projectilePosition2 = getPosWorld _projectile;									// position of projectile after waiting period
private _distance2D	= _projectilePositionT0 distance2D _projectilePosition2;			// calculate 2D distance (x axis value) between the two positions
private _heightDiff	= _projectilePosition2 #2 - _projectilePositionT0 #2;				// calculate height (y axis value) between the two positions; only working if round travels up!
private _elevAnkle	= atan (_heightDiff / _distance2D);									// calculate elevation angle of initial projectile flight trajectory
private _heading 	= _projectilePositionT0 getDir _projectilePosition2;				// calculate heading of projectile flight trajectory
private _heightImpactPosition = 0;														// we assume the height at impact position will be at zero m above sea level
private _g = 9.81;																		// gravitational constant in m/s^2
private _i = 0;
private ["_range", "_pedictedImpactPos"];
while {_i < 5} do {
	_heightDiff = _projectilePositionT0 #2 - _heightImpactPosition;
	_range = _Vzero * cos _elevAnkle * (_Vzero * sin _elevAnkle + sqrt((_Vzero * sin _elevAnkle)^2 + 2 * _g * _heightDiff)) / _g;				// calculate range of round. Formula: R = V0 * cos(α) * [V * sin(α) + √(V0 * sin(α))² + 2 * g * h)] / g. Source: https://www.omnicalculator.com/physics/projectile-motion
	_pedictedImpactPos = _projectilePositionT0 getPos [_range, _heading];																		// calculate predicted impact position
	if (getTerrainHeightASL _pedictedImpactPos < 0 || abs (_heightImpactPosition - getTerrainHeightASL _pedictedImpactPos) < 10) exitWith {};	// leave, if terrain height at predicted impact position is almost the same as the height predicted impact position was calculated with
	_heightImpactPosition = getTerrainHeightASL _pedictedImpactPos;																				// get terrain height position at calculated impact position
	_i = _i + 1;
};
_pedictedImpactPos set [2, 0];															// set impact height to zero above terrain level

if (_eta) then {
	private _Vy = _Vzero * sin _elevAnkle;
	_eta = floor ((_Vy + sqrt(_Vy^2 + 2 * _g * _heightDiff)) / _g);						// calculate time of flight. Formula: Vy = V0 * sin(α); t = [Vy + √(Vy² + 2 * g * h)] / g. Source: https://www.omnicalculator.com/physics/trajectory-projectile-motion#trajectory-formula
	// private _hmax = _heightDiff + _Vy^2 / (2 * _g); // hmax = h + Vy² / (2 * g)
};

[_pedictedImpactPos, _eta]
