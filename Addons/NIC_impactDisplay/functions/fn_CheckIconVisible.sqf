/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_CheckIconVisible
	Version: 		1.0
	Edited Date: 	18.08.2021
	
	Description:
		Check, if player is connected to a UAV listed in NIC_IMP_DSP_ICON_ENABLED_VEHICLES and if player
		is in gunner position of that UAV.
	
	Parameters:
		_player:		Object - player
		_vehicle:		Object - UAV player is connected to
	
	Returns:
		bool
*/

// NIC_IMP_DSP_fnc_CheckIconVisible = {
params [["_player", objNull], ["_vehicle", objNull]];
if (isNull _player || isNull _vehicle) exitWith {false};
private _return = false;
private _indexGunner = 1;
if (count UAVControl _vehicle > 2) then {_indexGunner = 3};			// in case 2 players are connected
{
	if (typeOf _vehicle == _x && UAVControl _vehicle # _indexGunner == "GUNNER") exitWith {_return = true}
} forEach NIC_IMP_DSP_ICON_ENABLED_VEHICLES;
_return
// };
