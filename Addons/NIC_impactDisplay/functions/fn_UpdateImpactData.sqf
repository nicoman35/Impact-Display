/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_ProjectileMonitor
	Version: 		1.0
	Edited Date: 	07.09.2021
	
	Description:
		Constantly update array NIC_Arty_ImpactData containing information for
		displayed impact icons (eta and impact position). Dependent on type of ammo
		used.
	
	Parameters:
		None
	
	Returns:
		None
*/

private ["_projectile", "_special", "_oldImpactPosition", "_oldImpactETA", "_memorizedImpactPosition", "_coordinates", "_newImpactPosition", "_heading", "_impactData", "_impactETA"];
private _flightEndTime = 6;																	// seconds before round will impact; begin of eta recalculation
private _distanceResolution = 0.5;															// how far the new impact position has to be from old impact position for new icon to be drawn
while {count NIC_Arty_ImpactData > 0} do {
	{
		_projectile = _x #3;
		if (isNull _projectile) exitWith {};
		_special = _x #4;
		if (_x #2 > _flightEndTime && _special == 0) exitWith {};
		_oldImpactPosition = _x #0;
		_oldImpactETA = _x #2;

		if (_special == 0 || _x #2 <= _flightEndTime) then {
			_impactData = [_projectile, true] call NIC_IMP_DSP_fnc_CalcImpactData;
			if (count _impactData == 0) exitWith {};
			_newImpactETA = _impactData #1;
			if (abs(_oldImpactETA - _newImpactETA) > 1) then {_x set [2, _newImpactETA]};	// let's recalculate ETA, for it can get imprecise over long distances
			if (_special > 0) exitWith {};													// no impact position recalculation for precision ammo
			_newImpactPosition = _impactData #0;
		};

		if (_special == 1) then {
			_memorizedImpactPosition = _x #5;
			_newImpactPosition = _memorizedImpactPosition;
			_cursorObject = _x #6;
			if (isNull _cursorObject || !alive _cursorObject) exitWith {};					// ? not sure, if round will no longer follow object, once it is dead. Further investigation needed
			_initialPositionObject = _x #7;													// initial position of targeted object
			if (_initialPositionObject distance _cursorObject < 100) then {					// if cursor position vehicle laser is on, laser guided round will hit initial memorized position
				_newImpactPosition = getPos _cursorObject;
			};
		};
		
		if (_special == 2) then {		// if round is laser guided, update impact position
			_memorizedImpactPosition = _x #5;
			_newImpactPosition = _memorizedImpactPosition;
			_positionCrosshair = screenToWorld [0.5, 0.5];
			if (_positionCrosshair distance _memorizedImpactPosition < 100 && isLaserOn getConnectedUAV player) then {	 // if cursor position vehicle laser is on, laser guided round will hit initial memorized position
				_newImpactPosition = _positionCrosshair;
			};
		};
		
		if (_oldImpactPosition distance _newImpactPosition > _distanceResolution) then {
			if (_special == 0) then {
				_heading = _oldImpactPosition getDir _newImpactPosition;
				_newImpactPosition = _oldImpactPosition getPos [_distanceResolution, _heading];
			};
			_x set [0, _newImpactPosition];
		};
	} forEach NIC_Arty_ImpactData;
};