/*
	Author: 		Nicoman
	Function: 		NIC_IMP_DSP_fnc_ImpDspInit
	Version: 		1.0
	Edited Date: 	18.08.2021
	
	Description:
		Iniciate rearm heavy weapons mod. Setup variables, add fired event handler to units listed in 
		NIC_IMP_DSP_MONITORED_VEHICLES
	
	Parameters:
		None
	
	Returns:
		None
*/

NIC_IMP_DSP_MONITORED_VEHICLES = [																					// infinite ammo resupply sources for heavy weapons
	"MBT_01_arty_base_F",
	"MBT_01_mlrs_base_F",
	"B_Ship_Gun_01_base_F",
	"StaticMortar"
];

NIC_IMP_DSP_AMMO_LIST = [									// Artillery ammo list in format [Magazine name, danger distance from impact point in m, display name]
	["8Rnd_82mm_Mo_shells", 80, "82 mm HE"],
	["8Rnd_82mm_Mo_Flare_white", 0, "82 mm Flare"],
	["8Rnd_82mm_Mo_Smoke_white", 0, "82 mm Smoke"],
	["32Rnd_155mm_Mo_shells", 150, "155 mm HE"],
	["4Rnd_155mm_Mo_guided", 80, "155 mm Guided"],
	["6Rnd_155mm_Mo_mine", 100, "155 mm AP Mines"],
	["2Rnd_155mm_Mo_Cluster", 150, "155 mm Cluster"],
	["6Rnd_155mm_Mo_smoke", 0, "155 mm Smoke"],
	["2Rnd_155mm_Mo_LG", 50, "155 mm Laser Guided"],
	["6Rnd_155mm_Mo_AT_mine", 120, "155 mm AT Mines"],
	["magazine_ShipCannon_120mm_HE_shells_x32", 100, "120 mm HE"],
	["magazine_ShipCannon_120mm_HE_guided_shells_x2", 50, "120 mm Guided"],
	["magazine_ShipCannon_120mm_HE_LG_shells_x2", 50, "120 mm Laser Guided"],
	["magazine_ShipCannon_120mm_HE_cluster_shells_x2", 100, "120 mm Cluster"],
	["magazine_ShipCannon_120mm_mine_shells_x6", 100, "120 mm AP Mines"],
	["magazine_ShipCannon_120mm_smoke_shells_x6", 0, "120 mm Smoke"],
	["magazine_ShipCannon_120mm_AT_mine_shells_x6", 100, "120 mm AT Mines"],
	["12Rnd_230mm_rockets", 150, "227 mm HE"]
];

NIC_IMP_DSP_DIRECTIONS = [ // Escape directions in case of near mortar fire [compass heading to impact point, opposite direction]
	[337, "South"],
	[293, "South West"],
	[248, "West"],
	[203, "North West"],
	[158, "North"],
	[113, "North East"],
	[68, "East"],
	[23, "South East"]
];

NIC_IMP_DSP_ICON_ENABLED_VEHICLES = [	// List of vehicles imact icons are visible from to player, when in gunner position																			// infinite ammo resupply sources for heavy weapons
	"B_UAV_05_F_Enhanced",
	"NIC_UGV_01_Enhanced"
];

{
	[_x, "fired", {_this spawn NIC_IMP_DSP_fnc_GetImpactData}, true] call CBA_fnc_addClassEventHandler;
} forEach NIC_IMP_DSP_MONITORED_VEHICLES;
			
// diag_log formatText ["%1%2%3%4%5", time, "s  NIC_IMP_DSP_fnc_ImpDspInit	EH added to arty"];