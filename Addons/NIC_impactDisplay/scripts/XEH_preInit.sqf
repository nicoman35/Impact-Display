[
	"NIC_IMP_DSP_MONITOR_CMD", 																		// internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX",																						// setting type
	[format[localize "STR_NIC_IMP_DSP_CMD"], format[localize "STR_NIC_IMP_DSP_CMD_TIP"]],			// [setting name, tooltip]
	format[localize "STR_NIC_IMP_DSP_TITLE"], 														// pretty name of the category where the setting can be found. Can be stringtable entry.
	true,																							// data for this setting: [min, max, default, number of shown trailing decimals]
    true																							// "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer																						// code executed on setting change
	{[] spawn NIC_IMP_DSP_fnc_MonitorCmdMenu}														// code executed on setting change AND when game is loaded
] call CBA_fnc_addSetting;
[
	"NIC_IMP_DSP_MONITOR_PLAYER",
	"CHECKBOX",
	[format[localize "STR_NIC_IMP_DSP_AC"], format[localize "STR_NIC_IMP_DSP_AC_TIP"]],
	format[localize "STR_NIC_IMP_DSP_TITLE"],
	true,
	true
	{[] spawn NIC_IMP_DSP_fnc_MonitorPlayer}
] call CBA_fnc_addSetting;