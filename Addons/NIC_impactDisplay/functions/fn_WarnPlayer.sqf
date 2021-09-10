/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_WarnPlayer
	Version: 		1.1
	Edited Date: 	07.09.2021
	
	Description:
		Issue warning to all players near an impact position. Give information when, where, and heading of the
		danger. Suggest escape route.
	
	Parameters:
		_unit:				Object - vehicle, from which the round was shot
		_magazine: 			String - magazine name which was used
		_impactETA:			Number - calculated time in seconds until impact
		_ammoData: 			Array - contains information about projectile listed in the variable NIC_IMP_DSP_AMMO_LIST
		_impactPosition:	Array - calculated impact position [x, y, z]
	
	Returns:
		None
*/

params [["_unit", [objNull]], ["_magazine", ""], ["_impactETA", 0], ["_ammoData", []], ["_impactPosition", []]];
if (isNull _unit || _magazine == "" || _impactETA == 0 || count _ammoData == 0 || count _impactPosition == 0) exitWith {};

sleep 5;
private ["_distance", "_heading", "_escapeDirection"];
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
