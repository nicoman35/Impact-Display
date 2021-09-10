/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_MonitorPlayer
	Version: 		1.0
	Edited Date: 	10.09.2021
	
	Description:
		Loop for monitoring player calling artillery computer. When the player opens the artillery computer,
		it will check the world coordinates of set fire marker. The position is then 
		memorized on player's vehicle, if vehicle is listed in NIC_IMP_DSP_MONITORED_VEHICLES.
	
	Parameters:
		None
	
	Returns:
		None
*/

waitUntil {time > 0};
sleep random 5;
if (player getVariable "NIC_IMP_DSP_MonitorPlayerMutex") exitWith {};	// we only want ONE instance of the monitor per player
player setVariable ["NIC_IMP_DSP_MonitorPlayerMutex", true];
disableSerialization;   
private "_displ";
while {NIC_IMP_DSP_MONITOR_PLAYER} do {     
	waitUntil {
		sleep 1;
		_displ = ({ if !(isNull (_x displayCtrl 510)) exitWith {_x}; displayNull} forEach allDisplays) displayCtrl 510;
		!isNull _displ;
	};
	_eventHandler = (findDisplay -1 displayCtrl 500) ctrlAddEventHandler ["mouseButtonDown", "_worldCoords = (_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3]; 
		_worldCoords pushBack 0;
		cameraOn setVariable ['NIC_IMP_DSP_cursorData', [_worldCoords, objNull, objNull, []]];
	"];
	waitUntil {isNull _displ};
	(findDisplay -1 displayCtrl 500) ctrlRemoveEventHandler ["mouseButtonDown", _eventHandler];
};
player setVariable ["NIC_IMP_DSP_MonitorPlayerMutex", nil];
