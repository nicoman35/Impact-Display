/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_MonitorCmdMenu
	Version: 		1.0
	Edited Date: 	03.10.2021
	
	Description:
		Loop for monitoring player calling command menu. When the player opens the command menu,
		it will constantly check the world coordinates of the mouse position. The position is then 
		memorized on every vehicle selected units are in listed in NIC_IMP_DSP_MONITORED_VEHICLES.
		Workaround for missing event when player gives fire command to an artillery unit. Is ment to be 
		the central coordinate for guided / laser guided ammo.
	
	Parameters:
		None
	
	Returns:
		None
*/

waitUntil {time > 0};
if (time < 2) then {sleep random 5};

if (player getVariable "NIC_IMP_DSP_MonitorCmdMenuMutex") exitWith {};																// we only want ONE instance of the monitor per player
player setVariable ["NIC_IMP_DSP_MonitorCmdMenuMutex", true];
disableSerialization;

private ["_vehicle", "_positionCrosshair", "_cursorObject", "_initialPositionObject", "_selectedUnits"];
while {NIC_IMP_DSP_MONITOR_CMD} do {																								// while monitoring of player command menu allowed
	waitUntil {																														// wait until player opens command menu
		sleep 0.5;
		commandingMenu == "RscGroupRootMenu" || commandingMenu == "#ARTILLERY";
	};
	_selectedUnits = [];
	while {commandingMenu != ""} do {																								// while command menu is open
		if (count groupSelectedUnits player > 0) then {
			_selectedUnits = groupSelectedUnits player;																				// monitor which units are selected 
			_cursorObject = cursorObject;
			_initialPositionObject = getpos cursorObject;
			if (cameraView == "EXTERNAL") exitWith {																				// 3. person camera view
				_positionCrosshair = lineIntersectsSurfaces [
					AGLToASL positionCameraToWorld [0, 0, 0], 
					AGLToASL positionCameraToWorld [0, 0, 5000], 
					player,
					objNull,
					true,
					1,
					"VIEW",
					"NONE"
				];
			};
			if (cameraView == "GROUP") exitWith {_positionCrosshair = [0, 0, 0]};													// can't get cursor coordinates in commander view, change, if there should be a way
			_positionCrosshair = screenToWorld [0.5, 0.5];																			// monitor position coordinates of targeting cursor
			if (visibleMap) then {
				_positionCrosshair = (findDisplay 12 displayCtrl 51) ctrlMapScreenToWorld getMousePosition;							// if map is open, monitor position coordinates of mouse position on map
				_positionCrosshair pushBack 0;
			};
		}; 
		sleep 0.1;
	}; 

	{
		_vehicle = vehicle _x;
		if (_vehicle != _x && _x == gunner _vehicle) then {
			{
				if (_vehicle isKindOf _x) exitWith {
					_vehicle setVariable ["NIC_IMP_DSP_cursorData", [_positionCrosshair, _cursorObject, _initialPositionObject]];	// if a unit is in a vehicle listed in NIC_IMP_DSP_MONITORED_VEHICLES, memory coordinates on that vehicle
				};
			} forEach NIC_IMP_DSP_MONITORED_VEHICLES;
		};
	} forEach _selectedUnits;
};
player setVariable ["NIC_IMP_DSP_MonitorCmdMenuMutex", nil];
