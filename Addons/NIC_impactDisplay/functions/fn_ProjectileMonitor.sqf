/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_ProjectileMonitor
	Version: 		1.0
	Edited Date: 	18.08.2021
	
	Description:
		1. Monitor projectiles fired from artillery units, display impact positions as icons, if player
			is in gunner position of a vehicle listed in NIC_IMP_DSP_ICON_ENABLED_VEHICLES
		2. If a projectile's impact position is near the player, warn player via hint when, where and
			which projectile will impact near him; suggest escape route
	
	Parameters:
		_unit:				Object - vehicle, from which the round was shot
		_magazine: 			String - magazine name which was used
		_impactETA:			Number - Calculated time in seconds until impact
		_ammoType: 			String - Ammo used
		_impactPosition:	Array - Calculated impact position [x, y, z]
		_projectile:		Object - projectile fired from artillery unit
	
	Returns:
		None
*/

// NIC_IMP_DSP_fnc_ProjectileMonitor_dbg = {
params [["_unit", [objNull]], ["_magazine", ""], ["_impactETA", 0], ["_ammoType", ""], ["_impactPosition", []], ["_projectile", [objNull]]];
if (_impactETA == 0 || (count _impactPosition) == 0 || isNull _projectile) exitWith {};

if (isNil "NIC_Arty_ImpactData") then {NIC_Arty_ImpactData = []};				// define impact data array

private _ammoName = _ammoType;
private _ammoData = (NIC_IMP_DSP_AMMO_LIST select {_x #0 == _magazine}) #0;
if (!isNil{_ammoData}) then {
	_ammoName = _ammoData #2;
	[_unit, _ammoData, _impactPosition, _impactETA] spawn {
		// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "sn  (NIC_IMP_DSP_fnc_ProjectileMonitor, warning spawn) _ammoData: ", _ammoData, ", _impactPosition: ", _impactPosition, ", _impactETA: ", _impactETA];
		params [["_unit", [objNull]], ["_ammoData", []], ["_impactPosition", []], ["_impactETA", 0]];
		if (isNull _unit || count _ammoData == 0 || count _impactPosition == 0 || _impactETA == 0) exitWith {};

		sleep 5;
		private ["_distance", "_heading", "_escapeDirection", "_warning"];
		{
			if (_ammoData #1 > 0 && _x distance _impactPosition < _ammoData #1 && alive _x) then {
				_distance = 10 * (round((_x distance _impactPosition) / 10));
				_heading = 10 * (round(_x getDir _impactPosition) / 10);
				_escapeDirection = "South";
				{
					if (_heading >= _x #0) exitWith {_escapeDirection = _x #1};
				} forEach NIC_IMP_DSP_DIRECTIONS;
				hint parsetext format ["<br /><t align='center' color='#FFFFFF' size='1.0'>Sir, DANGER!</t><br /><t align='center' color='#FFFFFF' size='1.0'>Incomming %1 shell!</t><br /><t align='center' color='#FFFFFF' size='1.0'>Impact in %2 seconds!</t><br /><t align='center' color='#FFFFFF' size='1.0'>Approximately %3 m heading %4 from your position!</t><br /><br /><t align='center' color='#FF0000' size='1.4'>Run to the %5!</t>" , _ammoData #2, _impactETA, _distance, _heading, _escapeDirection];
			};	
		} forEach allPlayers;
	};
};

// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_IMP_DSP_fnc_ProjectileMonitor) _ammoData: ", _ammoData];
NIC_Arty_ImpactData pushBack [_impactPosition, _ammoName, _impactETA, _projectile, _impactPosition];
if ((count NIC_Arty_ImpactData) > 1) exitWith {};
// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_IMP_DSP_fnc_ProjectileMonitor) NIC_Arty_ImpactData: ", NIC_Arty_ImpactData];

private _eventHandlerId = addMissionEventHandler ["draw3D", {
	_opacity = 0;
	if ([player, getConnectedUAV player] call NIC_IMP_DSP_fnc_CheckIconVisible) then {_opacity = 1};
	{
		_ImpactPosition = _x #0;
		_k = 10 / (player distance _ImpactPosition);
		_ammoType = _x #1;
		_impactETA = _x #2;
		drawIcon3D [
			"\a3\3den\data\cfgwaypoints\destroy_ca.paa", 				// icon image
			[1, 1, 1, _opacity], 										// icon color  [R, G, B, Opacity]
			_ImpactPosition, 											// icon position			
			1, 															// icon width
			1, 															// icon height 
			0, 															// icon rotation angle
			format["%1 %2 s", _ammoType, _impactETA],					// text
			0,															// shadow (0 = none)
			0.03,														// text size 
			"RobotoCondensed",											// text font 
			"right", 													// text alignment ("left", "center", "right")
			false,														// draw arrows and the text label at edge of screen when icon moves off screen
			0.005 * _k,													// offsetX
			-0.035 * _k													// offsetY
		];
	} forEach NIC_Arty_ImpactData;
}];
// cameraEffectEnableHUD true;											// Enable / disable showing of in-game UI during currently active camera effect

private _index = count NIC_Arty_ImpactData - 1;
(NIC_Arty_ImpactData #_index) pushBack _eventHandlerId;

[] spawn {
	private ["_projectile", "_newImpactPosition", "_oldImpactPosition", "_heading"];
	while {count NIC_Arty_ImpactData > 0} do {
		{
			_projectile = _x #3;
			if (!isNull _projectile && _x #2 < 5) then {
				_oldImpactPosition = _x #0;
				_newImpactPosition = [_projectile] call NIC_IMP_DSP_fnc_CalcImpactData;
				// diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_GetImpactData) _oldImpactPosition: ", _oldImpactPosition, ", _newImpactPosition: ", _newImpactPosition, ", distance: ", _oldImpactPosition distance _newImpactPosition];
				if (count _newImpactPosition == 0) exitWith {};
				if (_oldImpactPosition distance _newImpactPosition > 5) then {
					_heading = _oldImpactPosition getDir _newImpactPosition;
					_newImpactPosition = _oldImpactPosition getPos [5, _heading];
					// diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_GetImpactData) corrected _newImpactPosition: ", _newImpactPosition];
				};
				_x set [0, _newImpactPosition];
			} else {sleep NIC_IMP_DSP_wait};
		} forEach NIC_Arty_ImpactData;
	};
};

private ["_impactETA"];
while {(count NIC_Arty_ImpactData) > 0} do {
	{
		_impactETA = _x #2;
		_impactETA = _impactETA - 1;
		_x set [2, _impactETA];
		if (_impactETA < 1) then {NIC_Arty_ImpactData deleteAt _foreachindex};
	} forEach NIC_Arty_ImpactData;
	// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_IMP_DSP_fnc_ProjectileMonitor_dbg) NIC_Arty_ImpactData: ", NIC_Arty_ImpactData];
	sleep 1;
};
removeMissionEventHandler ["draw3D", _eventHandlerId];
// };