/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_GetImpactData
	Version: 		1.0
	Edited Date: 	18.08.2021
	
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

if (isNil{(NIC_IMP_DSP_AMMO_LIST select {_x #0 == _magazine}) #0}) exitWith {};  		// Exit, if magazine projectile is fired from is not registered	in NIC_IMP_DSP_AMMO_LIST
private _pedictedImpactPos = [_projectile] call NIC_IMP_DSP_fnc_CalcImpactData;
private _impactETA = floor (_unit getArtilleryETA [_pedictedImpactPos, _magazine]);
_pedictedImpactPos set [2, 0];
[_unit, _magazine, _impactETA, _ammo, _pedictedImpactPos, _projectile] spawn NIC_IMP_DSP_fnc_ProjectileMonitor;
// };

// NIC_IMP_DSP_fnc_CalcImpactData_dbg = {
	// params [["_projectile", [objNull]]];
	// if (isNull _projectile) exitWith {[]};
	
	// private _projectilePositionT0 = getPosWorld _projectile;
	// private _Vzero = (speed _projectile) / 3.6;				// speed in m/s 
	// // diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_IMP_DSP_fnc_CalcImpactData_dbg) _projectile: ", _projectile, ", _projectilePositionT0: ", _projectilePositionT0, ", _Vzero: ", _Vzero, " m/s"];
	// sleep 0.1;
	// if (isNull _projectile || !alive _projectile) exitWith {[]};
	// private _projectilePosition2 = getPosWorld _projectile;
	// private _distance2D	= _projectilePositionT0 distance2D _projectilePosition2;
	// private _heightDiff	= _projectilePosition2 #2 - _projectilePositionT0 #2;
	// private _elevAnkle	= atan (_heightDiff / _distance2D);									// elevation angle from safe position to medic
	// private _heading 	= _projectilePositionT0 getDir _projectilePosition2;
	// // diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_CalcImpactData_dbg) _projectilePosition2: ", _projectilePosition2, ", _distance2D: ", _distance2D, ", _heightDiff: ", _heightDiff, ", _elevAnkle: ", _elevAnkle, ", _heading: ", _heading];
	// // diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_CalcImpactData_dbg) tan _elevAnkle: ", tan _elevAnkle, ", cos _elevAnkle: ", cos _elevAnkle];
	// private _heightImpactPosition = 0;
	// private _i = 0;
	// private ["_range", "_pedictedImpactPos"];
	// while {_i < 5} do {
		// _heightDiff = _projectilePositionT0 #2 - _heightImpactPosition;
		// _range = _Vzero * cos _elevAnkle * (_Vzero * sin _elevAnkle + sqrt((_Vzero * sin _elevAnkle)^2 + 2 * 9.81 * _heightDiff)) / 9.81;
		// _pedictedImpactPos = _projectilePositionT0 getPos [_range, _heading];
		// // diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_GetImpactData) _heightImpactPosition: ", _heightImpactPosition, ", _pedictedImpactPos: ", _pedictedImpactPos];
		// if (getTerrainHeightASL _pedictedImpactPos < 0 || abs (_heightImpactPosition - getTerrainHeightASL _pedictedImpactPos) < 10) exitWith {};
		// _heightImpactPosition = getTerrainHeightASL _pedictedImpactPos;
		// _i = _i + 1;
	// };
	// _pedictedImpactPos set [2, 0];
	// _pedictedImpactPos
// };
	
// NIC_IMP_DSP_fnc_ProjectileMonitor_dbg = {
	// params [["_unit", [objNull]], ["_magazine", ""], ["_impactETA", 0], ["_ammoType", ""], ["_impactPosition", []], ["_projectile", [objNull]]];
	// if (_impactETA == 0 || (count _impactPosition) == 0 || isNull _projectile) exitWith {};
	
	// if (isNil "NIC_Arty_ImpactData") then {NIC_Arty_ImpactData = []};				// define impact data array

	// private _ammoName = _ammoType;
	// private _ammoData = (NIC_IMP_DSP_AMMO_LIST select {_x #0 == _magazine}) #0;
	// if (!isNil{_ammoData}) then {
		// _ammoName = _ammoData #2;
		// [_unit, _ammoData, _impactPosition, _impactETA] spawn {
			// // diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "sn  (NIC_IMP_DSP_fnc_ProjectileMonitor, warning spawn) _ammoData: ", _ammoData, ", _impactPosition: ", _impactPosition, ", _impactETA: ", _impactETA];
			// params [["_unit", [objNull]], ["_ammoData", []], ["_impactPosition", []], ["_impactETA", 0]];
			// if (isNull _unit || count _ammoData == 0 || count _impactPosition == 0 || _impactETA == 0) exitWith {};

			// sleep 5;
			// private ["_distance", "_heading", "_escapeDirection", "_warning"];
			// {
				// if (_ammoData #1 > 0 && _x distance _impactPosition < _ammoData #1 && alive _x) then {
					// _distance = 10 * (round((_x distance _impactPosition) / 10));
					// _heading = 10 * (round(_x getDir _impactPosition) / 10);
					// _escapeDirection = "South";
					// {
						// if (_heading >= _x #0) exitWith {_escapeDirection = _x #1};
					// } forEach NIC_IMP_DSP_DIRECTIONS;
					// hint parsetext format ["<br /><t align='center' color='#FFFFFF' size='1.0'>Sir, DANGER!</t><br /><t align='center' color='#FFFFFF' size='1.0'>Incomming %1 shell!</t><br /><t align='center' color='#FFFFFF' size='1.0'>Impact in %2 seconds!</t><br /><t align='center' color='#FFFFFF' size='1.0'>Approximately %3 m heading %4 from your position!</t><br /><br /><t align='center' color='#FF0000' size='1.4'>Run to the %5!</t>" , _ammoData #2, _impactETA, _distance, _heading, _escapeDirection];
				// };	
			// } forEach allPlayers;
		// };
	// };
	
	// // diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_IMP_DSP_fnc_ProjectileMonitor) _ammoData: ", _ammoData];
	// NIC_Arty_ImpactData pushBack [_impactPosition, _ammoName, _impactETA, _projectile, _impactPosition];
	// if ((count NIC_Arty_ImpactData) > 1) exitWith {};
	// // diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_IMP_DSP_fnc_ProjectileMonitor) NIC_Arty_ImpactData: ", NIC_Arty_ImpactData];

	// private _eventHandlerId = addMissionEventHandler ["draw3D", {
		// _opacity = 1;
		// if ([player, getConnectedUAV player] call NIC_IMP_DSP_fnc_CheckIconVisible_dbg) then {_opacity = 1};
		// {
			// _ImpactPosition = _x #0;
			// _k = 10 / (player distance _ImpactPosition);
			// _ammoType = _x #1;
			// _impactETA = _x #2;
			// drawIcon3D [
				// "\a3\3den\data\cfgwaypoints\destroy_ca.paa", 				// icon image
				// [1, 1, 1, _opacity], 										// icon color  [R, G, B, Opacity]
				// _ImpactPosition, 											// icon position			
				// 1, 															// icon width
				// 1, 															// icon height 
				// 0, 															// icon rotation angle
				// format["%1 %2 s", _ammoType, _impactETA],					// text
				// 0,															// shadow (0 = none)
				// 0.03,														// text size 
				// "RobotoCondensed",											// text font 
				// "right", 													// text alignment ("left", "center", "right")
				// false,														// draw arrows and the text label at edge of screen when icon moves off screen
				// 0.005 * _k,													// offsetX
				// -0.035 * _k													// offsetY
			// ];
		// } forEach NIC_Arty_ImpactData;
	// }];
	// // cameraEffectEnableHUD true;											// Enable / disable showing of in-game UI during currently active camera effect
	// // cameraEffectEnableHUD false;											// Enable / disable showing of in-game UI during currently active camera effect

	// private _index = count NIC_Arty_ImpactData - 1;
	// (NIC_Arty_ImpactData #_index) pushBack _eventHandlerId;
	
	// [] spawn {
		// private ["_projectile", "_newImpactPosition", "_oldImpactPosition", "_heading"];
		// while {count NIC_Arty_ImpactData > 0} do {
			// {
				// _projectile = _x #3;
				// if (!isNull _projectile && _x #2 < 5) then {
					// _oldImpactPosition = _x #0;
					// _newImpactPosition = [_projectile] call NIC_IMP_DSP_fnc_CalcImpactData_dbg;
					// // diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_GetImpactData) _oldImpactPosition: ", _oldImpactPosition, ", _newImpactPosition: ", _newImpactPosition, ", distance: ", _oldImpactPosition distance _newImpactPosition];
					// if (count _newImpactPosition == 0) exitWith {};
					// if (_oldImpactPosition distance _newImpactPosition > 5) then {
						// _heading = _oldImpactPosition getDir _newImpactPosition;
						// _newImpactPosition = _oldImpactPosition getPos [5, _heading];
						// // diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11", time, "s  (NIC_IMP_DSP_fnc_GetImpactData) corrected _newImpactPosition: ", _newImpactPosition];
					// };
					// _x set [0, _newImpactPosition];
				// } else {sleep 0.1};
			// } forEach NIC_Arty_ImpactData;
		// };
	// };
	
	// private ["_impactETA"];
	// while {(count NIC_Arty_ImpactData) > 0} do {
		// {
			// _impactETA = _x #2;
			// _impactETA = _impactETA - 1;
			// _x set [2, _impactETA];
			// if (_impactETA < 1) then {NIC_Arty_ImpactData deleteAt _foreachindex};
		// } forEach NIC_Arty_ImpactData;
		// // diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_IMP_DSP_fnc_ProjectileMonitor_dbg) NIC_Arty_ImpactData: ", NIC_Arty_ImpactData];
		// sleep 1;
	// };
	// removeMissionEventHandler ["draw3D", _eventHandlerId];
// };

// NIC_IMP_DSP_fnc_CheckIconVisible_dbg = {
	// params [["_player", objNull], ["_vehicle", objNull]];
	// if (isNull _player || isNull _vehicle) exitWith {false};
	// private _return = false;
	// private _indexGunner = 1;
	// if (count UAVControl _vehicle > 2) then {_indexGunner = 3};	
	// {
		// if (typeOf _vehicle == _x && UAVControl _vehicle # _indexGunner == "GUNNER") exitWith {_return = true}
	// } forEach NIC_IMP_DSP_ICON_ENABLED_VEHICLES;
	// _return
// };


// player directSay "\a3\Sounds_F\sfx\hint-3";
// player sideRadio "messageOne";
// _sound[] = {"\a3\Sounds_F\sfx\hint-3",0.891251,1};