// General init of both server and clients

if(isServer) then {
    ["GSRI_ZeusManager_summoned", gsri_zeusmanager_fnc_handleSummons] call CBA_fnc_addEventHandler;

    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];
        [_unit] call GZM_fnc_releaseSlot;
        //Prevent unit from living after player's DC
        false
    }];
};

if!(isDedicated) then {
    // Tracking Zeus commands
    ["zeus", {
        // Retreive a GZM command and raise appropriate event
        params["_rawCommand"];
        private _fullCommand = _rawCommand splitString " ";
        private _command = _fullCommand select 0;
        private _allowedCommands = ["request", "release", "help"];
        if([] call BIS_fnc_admin > 1 || isServer) then {
            { _allowedCommands pushBack _x } forEach ["promote", "revoke", "whitelist", "import", "export"];
        };

        // Invalid commands
        if(
            !(_command in _allowedCommands)
            or (_command == "help")
            or (_command == "promote" && count _fullCommand != 3 )
            or (_command == "revoke" && count _fullCommand != 2 )
            or (_command in ["import", "export"] && count _fullCommand != 1 )
        ) exitWith {
            [_allowedCommands] spawn gsri_zeusmanager_fnc_help;
        };
        ["GSRI_ZeusManager_summoned", [player, _fullCommand]] call CBA_fnc_serverEvent;
    }, "all"] call CBA_fnc_registerChatCommand;

    // Retrieving and displaying server's responses
    ["GSRI_ZeusManager_answered", {_this spawn {
        private _string = _this select 0;
        _this set [0, localize _string];
        // A pause is needed so the command recall is displayed before the help lines
        sleep 0.1;
        systemChat format _this;
    }}] call CBA_fnc_addEventHandler;

    // Putting the whitelist import helper in place
    [ 
        "GSRI_ZeusManager_ImportHelper",
        "EDITBOX",
        ["STR_GSRI_ZeusManager_importHelper_title", "STR_GSRI_ZeusManager_importHelper_tooltip"],
        "GSRI Zeus Manager",
        "",
        true
    ] call CBA_fnc_addSetting;
    [ 
        "GSRI_ZeusManager_ImportForcer",
        "CHECKBOX",
        ["STR_GSRI_ZeusManager_importHelper_forcerTitle", "STR_GSRI_ZeusManager_importHelper_forcerTooltip"],
        "GSRI Zeus Manager",
        false,
        true
    ] call CBA_fnc_addSetting;
};
