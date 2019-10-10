// Already assigned
if!(isNull (getAssignedCuratorLogic player)) exitWith { systemChat format["Already assigned to slot %1", (getAssignedCuratorLogic player) getVariable "Name"] };

// Not allowed
if!(profileName in GZM_ZEUS_WHITELIST) exitWith { systemChat "You are not allowed as a Zeus user." };

{
	if(_x getVariable "Name" != "Admin" and isNull (getAssignedCuratorUnit _x)) exitWith {
		[player, _x] remoteExec ["assignCurator", 2];
		systemChat format ["Assigned to slot %1.", _x getVariable "Name"];
	};

	if(_forEachIndex == count allCurators - 1) then {systemChat "No Zeus slot available."};
} forEach allCurators;