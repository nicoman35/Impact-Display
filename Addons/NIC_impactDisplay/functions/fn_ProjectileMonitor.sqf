/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_ProjectileMonitor
	Version: 		1.1
	Edited Date: 	30.09.2021
	
	Description:
		1. Monitor projectiles fired from artillery units, display impact positions as icons, if player
			is in gunner position of a vehicle listed in NIC_IMP_DSP_ICON_ENABLED_VEHICLES
		2. If a projectile's impact position is near the player, warn player via hint when, where and
			which projectile will impact near him; suggest escape route
	
	Parameters:
		_unit:						Object - vehicle, from which the round was shot
		_magazine: 					String - magazine name which was used
		_impactETA:					Number - Calculated time in seconds until impact
		_ammoType: 					String - Ammo used
		_impactPosition:			Array - Calculated impact position [x, y, z]
		_projectile:				Object - projectile fired from artillery unit
		_special:					Number - 0: Dumb fire ammo, special = 1: Guided ammo, special = 2: Lasr guided ammo
		_memorizedImpactPosition:	Array - cursor position [x, y, z]
		_cursorObject:				Object - cursor object
		_initialPositionObject:		Array - object position [x, y, z]
		
	Returns:
		None
*/

params [
	["_unit", [objNull]], 
	["_magazine", ""], 
	["_impactETA", 0], 
	["_ammoType", ""], 
	["_impactPosition", []], 
	["_projectile", [objNull]], 
	["_special", 0], 
	["_memorizedImpactPosition", []],
	["_cursorObject", [objNull]], 
	["_initialPositionObject", []],
	["_flightEndTime", 0]
];

if (_impactETA == 0 || count _impactPosition == 0 || isNull _projectile || _flightEndTime == 0) exitWith {};

private _ammoData = (NIC_IMP_DSP_AMMO_LIST select {_x #0 == _magazine}) #0;
[_unit, _magazine, _impactETA , _ammoData, _impactPosition] spawn NIC_IMP_DSP_fnc_WarnPlayer;  // issue warning to all players near an impact position

private _ammoName = _ammoType;
if !(isNil{_ammoData}) then {_ammoName = _ammoData #2};
if (isNil "NIC_Arty_ImpactData") then {NIC_Arty_ImpactData = []};																		// define impact data array
NIC_Arty_ImpactData pushBack [_impactPosition, _ammoName, _impactETA, _projectile, _special, _memorizedImpactPosition, _cursorObject, _initialPositionObject, _flightEndTime];
if ((count NIC_Arty_ImpactData) > 1) exitWith {};																						// leave here, if we already monitor something
 
private _eventHandlerId = addMissionEventHandler ["draw3D", {
	_opacity = 0;
	if ([player, getConnectedUAV player] call NIC_IMP_DSP_fnc_CheckIconVisible) then {_opacity = 1};
	{
		_ImpactPosition = _x #0;
		_k = 10 / (player distance _ImpactPosition);
		_ammoType = _x #1;
		_impactETA = _x #2;
		drawIcon3D [
			// "\a3\3den\data\cfgwaypoints\destroy_ca.paa", 																			// icon image
			"\a3\ui_f\data\map\markerbrushes\cross_ca.paa", 																			// icon image
			[1, 1, 1, _opacity], 																										// icon color  [R, G, B, Opacity]
			_ImpactPosition, 																											// icon position			
			1, 																															// icon width
			1, 																															// icon height 
			0, 																															// icon rotation angle
			format["%1 %2 km %3 s", _ammoType, (round(_ImpactPosition distance getConnectedUAV player) / 1000) toFixed 2, _impactETA],	// text
			0,																															// shadow (0 = none)
			0.03,																														// text size 
			"PuristaLight",																												// text font 
			"right", 																													// text alignment ("left", "center", "right")
			false,																														// draw arrows and the text label at edge of screen when icon moves off screen
			0.005 * _k,																													// offsetX
			-0.035 * _k																													// offsetY
		];
	} forEach NIC_Arty_ImpactData;
}];

private _index = count NIC_Arty_ImpactData - 1;
(NIC_Arty_ImpactData #_index) pushBack _eventHandlerId;

[] spawn NIC_IMP_DSP_fnc_UpdateImpactData;  																						// begin updating the impact data array

private ["_impactETA"];
while {(count NIC_Arty_ImpactData) > 0} do {
	{
		_impactETA = _x #2;
		_impactETA = _impactETA - 1;
		_x set [2, _impactETA];
		_projectile = _x #3;
		if (_impactETA < 1 || !alive _projectile) then {NIC_Arty_ImpactData deleteAt _foreachindex};
	} forEach NIC_Arty_ImpactData;
	sleep 1;
};