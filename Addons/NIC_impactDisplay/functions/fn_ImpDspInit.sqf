/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_ImpDspInit
	Version: 		1.0
	Edited Date: 	31.08.2021
	
	Description:
		Iniciate rearm heavy weapons mod. Setup variables, add fired event handler to units listed in 
		NIC_IMP_DSP_MONITORED_VEHICLES
	
	Parameters:
		None
	
	Returns:
		None
*/

NIC_IMP_DSP_MONITORED_VEHICLES = [													// Vehicles monitored for fired event
	"MBT_01_arty_base_F",
	"MBT_01_mlrs_base_F",
	"B_Ship_Gun_01_base_F",
	"rhsusf_m109d_usarmy",
	"RHS_M119_D",
	"StaticMortar"
];

NIC_IMP_DSP_AMMO_LIST = [															// Artillery ammo list in format [Magazine name, danger distance from impact point in m, display name]
	["8Rnd_82mm_Mo_shells", 80, "82 mm HE", 0],
	["8Rnd_82mm_Mo_Flare_white", 0, "82 mm Flare", 0],
	["8Rnd_82mm_Mo_Smoke_white", 0, "82 mm Smoke", 0],
	["32Rnd_155mm_Mo_shells", 150, "155 mm HE", 0],
	["4Rnd_155mm_Mo_guided", 80, "155 mm Guided", 1],
	["6Rnd_155mm_Mo_mine", 100, "155 mm AP Mines", 0],
	["2Rnd_155mm_Mo_Cluster", 150, "155 mm Cluster", 0],
	["6Rnd_155mm_Mo_smoke", 0, "155 mm Smoke", 0],
	["2Rnd_155mm_Mo_LG", 50, "155 mm Laser Guided", 2],
	["6Rnd_155mm_Mo_AT_mine", 120, "155 mm AT Mines", 0],
	["magazine_ShipCannon_120mm_HE_shells_x32", 100, "120 mm HE", 0],
	["magazine_ShipCannon_120mm_HE_guided_shells_x2", 50, "120 mm Guided", 0],
	["magazine_ShipCannon_120mm_HE_LG_shells_x2", 50, "120 mm Laser Guided", 0],
	["magazine_ShipCannon_120mm_HE_cluster_shells_x2", 100, "120 mm Cluster", 0],
	["magazine_ShipCannon_120mm_mine_shells_x6", 100, "120 mm AP Mines", 0],
	["magazine_ShipCannon_120mm_smoke_shells_x6", 0, "120 mm Smoke", 0],
	["magazine_ShipCannon_120mm_AT_mine_shells_x6", 100, "120 mm AT Mines", 0],
	["12Rnd_230mm_rockets", 150, "227 mm HE", 0],
	["12Rnd_230mm_rockets_cluster", 150, "227 mm HE", 0],
	["rhs_mag_155mm_m795_28", 150, "155 mm HE", 0],
	["rhs_mag_155mm_m825a1_2", 0, "155 mm Smoke", 0],
	["rhs_mag_155mm_485_2", 0, "155 mm Flare", 0],
	["rhs_mag_155mm_m712_2", 50, "155 mm Laser Guided", 0],
	["rhs_mag_155mm_m731_1", 120, "155 mm AT Mines", 0],
	["rhs_mag_155mm_raams_1", 120, "155 mm AP Mines", 0],
	["rhs_mag_155mm_m864_3", 150, "155 mm Cluster", 0],
	["RHS_mag_m1_he_12", 100, "105 mm HE", 0],
	["rhs_mag_m314_ilum_4", 0, "105 mm Flare", 0],
	["rhs_mag_m60a2_smoke_4", 0, "105 mm Smoke", 0]
];

NIC_IMP_DSP_DIRECTIONS = [ 															// Escape directions in case of icomming shells near player; only friendly units [compass heading to impact point, opposite direction]
	[337, "South"],
	[293, "South West"],
	[248, "West"],
	[203, "North West"],
	[158, "North"],
	[113, "North East"],
	[68, "East"],
	[23, "South East"]
];

NIC_IMP_DSP_ICON_ENABLED_VEHICLES = [												// Vehicles imact icons are visible from to player, when in gunner position	
	"B_UAV_05_F_Enhanced",
	"NIC_UGV_01_Enhanced"
];

NIC_IMP_DSP_wait = 0.1;																// Wait period for trajectory calculation
if (isNil "NIC_IMP_DSP_MONITOR_CMD") then {NIC_IMP_DSP_MONITOR_CMD 		= true};	// Monitoring pf players opening command menu allowed
// [] spawn NIC_IMP_DSP_fnc_MonitorCmdMenu;											// Spawn loop for monitoring players opening command menu
if (isNil "NIC_IMP_DSP_MemoryMutex") then {NIC_IMP_DSP_MemoryMutex 		= false};

{
	[_x, "fired", {_this spawn NIC_IMP_DSP_fnc_GetImpactData_dbg}, true] call CBA_fnc_addClassEventHandler;
	// [_x, "fired", {_this spawn NIC_IMP_DSP_fnc_GetImpactData}, true] call CBA_fnc_addClassEventHandler;
} forEach NIC_IMP_DSP_MONITORED_VEHICLES;
