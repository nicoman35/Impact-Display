// [
	// "NIC_HW_REARM_ALLOWED", 																		// internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    // "CHECKBOX",																						// setting type
	// [format[localize "STR_NIC_HW_TITLE"], format[localize "STR_NIC_HW_TITLE_TIP"]],					// [setting name, tooltip]
	// format[localize "STR_NIC_HW_TITLE"], 															// pretty name of the category where the setting can be found. Can be stringtable entry.
	// true,																							// data for this setting: [min, max, default, number of shown trailing decimals]
    // true																							// "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
	// // {
		// // if (NIC_HW_REARM_ALLOWED) exitWith {_this call NIC_fn_ACTION_REARM_ON};
		// // _this call NIC_fn_ACTION_REARM_OFF;
	// // }																							// code executed on setting change
// ] call CBA_fnc_addSetting;
// [
	// "NIC_HW_REARM_SEARCH_RANGE",
	// "SLIDER",
	// [format[localize "STR_NIC_HW_SEARCH_RANGE"], format[localize "STR_NIC_HW_SEARCH_RANGE_TIP"]],
	// format[localize "STR_NIC_HW_TITLE"],
	// [10, 200, 125, 0],																				// [_min, _max, _default, _trailingDecimals]
    // true
// ] call CBA_fnc_addSetting;
// [
	// "NIC_HW_REARM_TIME_PER_MAGAZINE_AND_METER",
	// "SLIDER",
	// [format[localize "STR_NIC_HW_TIME_PER"], format[localize "STR_NIC_HW_TIME_PER_TIP"]],
	// format[localize "STR_NIC_HW_TITLE"],
	// [0.1, 10, 1, 1],
	// true
// ] call CBA_fnc_addSetting;
// [
	// "NIC_HW_REARM_AI_UNITS",
	// "SLIDER",
	// [format[localize "STR_NIC_HW_AI_UNITS"], format[localize "STR_NIC_HW_AI_UNITS_TIP"]],
	// format[localize "STR_NIC_HW_TITLE"],
	// [0, 3, 1, 0],
    // true
// ] call CBA_fnc_addSetting;