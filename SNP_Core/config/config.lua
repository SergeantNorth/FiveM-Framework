-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

Config = {}

-- MAIN CONFIG -- 
Config.maxchars = 10;

Config.version = "1.3.1"; -- DO NOT TOUCH -- 
Config.version_check = true;

Config.enabled_message = true;
Config.welcome_message = "Welcome to the SergeantNorth Framework";

Config.join_msg_as_circle_text = true;
Config.spawnloc_big = false -- if you want it to be small modal for the spawn loaction then change this to false otherwise change it to true

Config.checkDiscord = true -- will check if the user still have the roles and if he doesn't remove it.

-- DEFAULT PED SPAWN [COPS ONLY] -- 
Config.enable_default_ped_spawn = false
Config.male_ped = 's_m_y_cop_01'
Config.female_ped = 's_f_y_cop_01'

-- DISCORD OR ACE PERMS --
Config.use_discord = true;
Config.server_id = "0"
Config.users_roles = {
    ["bcso_level"] = "0", -- leave 0 if you want them to access it without having the role or the ace
    ["sast_level"] = "0", -- leave 0 if you want them to access it without having the role or the ace
    ["lspd_level"] = "0", -- leave 0 if you want them to access it without having the role or the ace
    ["safd_level"] = "0", -- leave 0 if you want them to access it without having the role or the ace
    ["civ_level"] = "0", -- leave 0 if you want them to access it without having the role or the ace
    ["admin_level"] = "0", -- do not leave this 0. Keeping this as zero will grant everyone admin perms
    ["PRIORTY"] = {
        1,
        1,
    }
}

-- Department names --
Config.dept_names = {
    ["lspd_level"] = "LSPD", -- only change the values in here do not touch anything within _level section
    ["bcso_level"] = "BCSO",
    ["sast_level"] = "SAST",
    ["safd_level"] = "SAFD",
    ["civ_level"] = "Civilian", -- whatever you change in here would be the civ name. There can only be one civ name
    ["admin_level"] = "Staff" -- DO not change the level here just change the name if you want no the admin_level
}

-- SPAWN -- 

-- to add spawns to the department ensure the name of the spawn is the same as the ones above ^ look at the layout of it right now that is an example --
Config.Spawns = {
    ["bcso_level"] = {
        {x=-447.307, y=6009.122, z=32.616, label="Paleto Bay Sheriff Station"},
        {x=1849.388, y=3689.164, z=34.270, label="Sandy Shores Sheriff Station"},
    },
    ["sast_level"] = {
        {x=-447.307, y=6009.122, z=32.616, label="Paleto Bay Substation"},
        {x=1535.06, y=812.83, z=77.66, label="SA State Police HQ"},
        {x=2506.297, y=-384.514, z=94.125, label="SAHP Headquarters"},
    },
    ["lspd_level"] = {
        {x=1849.388, y=3689.164, z=34.270, label="Sandy Shores Sheriff Station"},
        {x=450.515, y=-991.851, z=30.7, label="Mission Row Police Station"},
    },
    ["safd_level"] = {
        {x=-362.294, y=6130.17, z=31.4402, label="Paleto Bay Fire Station"},
    },
    ["civ_level"] = {
        {x =238.5, y =-878.5, z =31.5, label = 'Legion Square'},
        {x =1501.64, y =3758.03, z =33.94, label= 'Sandy Shores'}, 
        {x =-38.994251251221, y =6521.8715820313, z =31.490852355957, label = 'Paleto Bay'}
    },
    ["admin_level"] = {
        {x=-41.31, y=-1112.83, z=25.81, label="Los Santos"},
        {x=2464.8, y=4105.32, z=37.44, label="Sandy Shores"},
        {x=-267.43, y=6629.64, z=6.88, label="Paleto Bay"}
    },
}



-- FRAMEWORK BACKGROUNDS || FRAMEWORK LOGO -- 
Config.server_logo = true;
Config.refresh_button = true;
Config.disconnect_button = true;
Config.default_darkmode = true -- turn to false if you want it to be default light mode


Config.change_backgrounds = true; -- use random background picker from the array below
Config.background_slideshow = true -- background slideshow while the user is in the UI
Config.slidwshow_length = 7 -- how long until an img switchs the slide show must be enabled
Config.background_images = {
    "http(s)://domainhere.tld/imagename.imageext",
}


-- WHITELIST SYSTEM  [DISCORD MUST BE ENABLED FOR THIS TO WORK]-- 
Config.enable_whitelist = false
Config.whitelist_role = "0"
Config.notwhitelisted_msg = "WHITELIST MESSAGE HERE"

-- DISCORD BAN CHECKER [DISCORD MUST BE ENABLED FOR THIS TO WORK]-- 
Config.discord_ban_checker = true
Config.use_discord_ban_message = true -- change this to a string with the reason if you don't want to use the discord ban reason
Config.ban_default_message = "BAN MESSAGE HERE" -- if the user does not have a ban reason this will be the message it will display


-- TWITTER FILTER -- 
Config.blacklisted_word = {
    "nigger",
    "faggot",
    "kys",
    "nigga",
    "fag",
    "jew",
    "racist"
}
   

-- TWITTER FILTER -- 
Config.whitelist_word = {
    "niceguy",
    "coolkid21",
    "xboxplayer10",
    "newhere!"
}

-- PANIC SYSTEM -- [WIP] 
Config.enable_panic_system = true


-- SHOT SPOTER BELOW -- 
Config.shotspoter = true;
Config.wait_time_before_next_blip = 60000 -- this is in ms so example 30000 = 30 seconds
Config.shotspotter_timer = 1 -- this is in ms so example 30000 = 30 seconds
Config.blacklistedweapons = {
    "WEAPON_UNARMED",
	"WEAPON_STUNGUN",
	"WEAPON_KNIFE",
	"WEAPON_KNUCKLE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_HAMMER",
	"WEAPON_BAT",
	"WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR",
	"WEAPON_BOTTLE",
	"WEAPON_DAGGER",
	"WEAPON_HATCHET",
	"WEAPON_MACHETE",
	"WEAPON_FLASHLIGHT",
	"WEAPON_SWITCHBLADE",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_PETROLCAN",
	"WEAPON_SNOWBALL",
	"WEAPON_FLARE",
	"WEAPON_BALL"
}

-- DOOR LOCK -- 
Config.enable_door_lock = true -- refer to confg_doors.lua for adding doors
Config.door_lock = "[E] Unlock"
Config.door_unlocked = "[E] Lock"

-- DEATH SYSTEM -- 
Config.enable_death_system = false
Config.enable_death_timer = true
Config.death_timer = 5 -- in seconds
Config.death_key = 51
Config.respawn_key = 45
Config.death_spots = {
    vector3(1866.86, 3696.04, 34.58), --Sandy Shores

  
}

-- AI WEAPON GIVER -- 
Config.enable_ai_cop_Weapon = true 
Config.weapon_per_dept = {
    ["BCSO"] = {
        {name = "Carbine Rifle", weapon_hash = "weapon_carbinerifle"},
        {name = "Combat Pistol", weapon_hash = "weapon_combatpistol"},
    },
    ["SAST"] = {
        {name = "Carbine Rifle", weapon_hash = "weapon_carbinerifle"},
        {name = "Combat Pistol", weapon_hash = "weapon_combatpistol"},
    },
    ["LSPD"] = {
        {name = "Carbine Rifle", weapon_hash = "weapon_carbinerifle"},
        {name = "Combat Pistol", weapon_hash = "weapon_combatpistol"},
    },
}

Config.cop_spots = {
    ["Misson Row"] = {
        vector4(454.05, -980.01, 30.69, 98.42) --format is x, y, z, h
    },
}
Config.default_cop_length = 2 -- distance to be in m
Config.default_keybind_to_open_menu = 38 -- Default E




-- TASER CART -- 
Config.tasercarts = true;
Config.maxtasercarts = 3;

-- CHAT BLOCKER -- 
Config.enable_chat_blocker = true;
Config.blacklisted_words = {
    "gay",
    "fag",
    "kys",
    "faggot",
    "nigger",
    "nigga",
    "doxxing",
    "dox"
}

-- CHAT CLEAR --
Config.enable_chat_clear = true;

-- CLEAR COPS -- 
Config.clearcops = true;

-- LOADOUT SYSTEM --
Config.spawnwithaloadout = true;

-- LEO BLIPS --
Config.enable_blips = true;
Config.show_officer_on_foot = false;
Config.autoenable_blips = false;

-- priority SCRIPT -- 
Config.enable_priority = true;
Config.leo_can_see_it = true;
Config.disable_view_on_hud_priority = false;
Config.admin_use_only = true;
Config.max_time = 45; --in minutes
Config.everyone_can_use_the_priority_command = true
Config.priority_draw = {
    x = 0.16,
    y = 0.885
}

-- AOP SCRIPT-- 
Config.enable_aop = true;
Config.leo_can_view_aop = true;
Config.disable_view_on_hud_aop = false;
Config.show_aop_on_framework = true;
Config.default_aop = "Sandy Shores";
Config.aop_draw = {
    x = 0.16,
    y = 0.905
}

-- PEACETIME -- 
Config.enable_peacetime = true;
Config.leo_can_view_peacetime = true;
Config.peacetime_affect_leo = false;
Config.disable_view_on_hud_peacetime = false;
Config.peactime_draw = {
    x = 0.16,
    y = 0.865
}

-- CLEAR WEAPONS --
Config.clearweapons_command = true;


-- CALL ADMIN -- 
Config.call_admin = true


-- DISCORD RICH PRESENCE -- 
Config.richpresence = true;
Config.client_id = 000000;
Config.big_icon = 'big_logo';
Config.big_text = 'BIGTEXT';

Config.small_icon = 'small_logo';
Config.small_text = 'discord.gg/sergeantnorth';

Config.show_char_playing = true;

Config.discord_buttons = true;
Config.button_1 = {
    label = "Discord",
    url = "https://discord.gg/sergeantnorth"
}
Config.remove_button_two = true;
Config.button_2 = {
    label = "Connect",
    url = "fivem://connect/IP:30120"
}


-- CHAT COMMANDS -- 
Config.enable_ooc_command = true
Config.enable_do_command = true
Config.enable_me_command = true
Config.enable_mer_command = true
Config.enable_dob_command = true
Config.enable_twt_command = true
Config.enable_gme_command = true
Config.enable_radio_command = true
Config.enable_ems_command = true
Config.enable_darkweb_command = true
Config.enable_whoami_command = true
Config.enable_loadout_command = true
Config.enable_911_command = true
Config.enable_admin_command = true
Config.enable_revive_all = true
Config.enable_tp_command = true