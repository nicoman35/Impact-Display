class CfgPatches {
	class NIC_IMP_DSP {
		units[]				= {};
		weapons[]= {};
		requiredVersion		= 1;
		requiredAddons[]	= {};
		magazines[]= {};
	};
};
class CfgFunctions {
	class NIC_IMP_DSP {
		class Functions {
			file="NIC_impactDisplay\functions";
			class ImpDspInit {
				preInit = 1;
			};
			class GetImpactData {};
			class CalcImpactData {};
			class ProjectileMonitor {};
			class CheckIconVisible {};
		};
	};
};