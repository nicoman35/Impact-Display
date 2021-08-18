if (!isNull player && player == player && time > 1) then {
	if !(isNil{NIC_HW_REARM_ALLOWED}) then {
		if (NIC_HW_REARM_ALLOWED) then {[_this select 0] call NIC_fnc_actionRearmON}
		else {[_this select 0] call NIC_fnc_actionRearmOFF};
	};
};