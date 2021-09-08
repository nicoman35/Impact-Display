class CfgPatches {
	class NIC_IMP_DSP {
		units[]				= {};
		weapons[]			= {};
		requiredVersion		= 1;
		requiredAddons[]	= {};
		magazines[]			= {};
	};
};
class CfgFunctions {
	class NIC_IMP_DSP {
		class Functions {
			file = "NIC_impactDisplay\functions";
			class ImpDspInit {
				preInit = 1;
			};
			class GetImpactData {};
			class CalcImpactData {};
			class ProjectileMonitor {};
			class CheckIconVisible {};
			class MonitorCmdMenu {};
			class WarnPlayer {};
			class UpdateImpactData {};
		};
	};
};
class Extended_PreInit_EventHandlers {
	class IMP_DSP {
		init = "call compile preprocessFileLineNumbers '\NIC_impactDisplay\scripts\XEH_preInit.sqf'"; // CBA_a3 integration
	};
};