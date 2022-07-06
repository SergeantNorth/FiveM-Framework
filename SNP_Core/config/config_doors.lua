-- CREDITS | DO NOT REMOVE --
-- Created by SergeantNorth#1650 --
-- Copyright SergeantNorth Productions --
-- discord.gg/sergeantnorth --

-- CREDITS https://github.com/JaredScar/Badger_Doorlock -- 
Config_doors = {}
Config_doors.DoorList = {

	{
		textCoords = vector3(434.7, -981.9, 30.8),
		authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
		locked = false,
		maxDistance = 2.5,
		doors = {
			{objHash = GetHashKey('gabz_mrpd_reception_entrancedoor'), objHeading = 90.1, objCoords = vector3(434.7, -983.0, 30.8)},
			{objHash = GetHashKey('gabz_mrpd_reception_entrancedoor'), objHeading = 269.0, objCoords = vector3(434.7, -980.7, 30.8)}
		}
	},

		-- Reception Side Door 1
		{
			objHash = GetHashKey('gabz_mrpd_door_05'),
			objHeading = 177.9,
			objCoords = vector3(440.5, -988.2, 30.8),
			textCoords = vector3(440.5, -986.2, 30.8),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 2.5
		},
	
		-- Reception Side Door 2
		{
			objHash = GetHashKey('gabz_mrpd_door_04'),
			objHeading = 2.6,
			objCoords = vector3(440.5, -977.6, 30.8),
			textCoords = vector3(440.5, -977.6, 30.8),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 2.5
		},
	
		-- Garage Parking Door 1
		{
			objHash = GetHashKey('gabz_mrpd_room13_parkingdoor'),
			objHeading = 88.0,
			objCoords = vector3(464.1, -997.5, 26.3),
			textCoords = vector3(464.1, -997.5, 26.3),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.5
		},
	
		-- Cells Door 1
		{
			textCoords = vector3(471.3, -1008.96, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 2.5,
			doors = {
				{objHash = GetHashKey('gabz_mrpd_door_02'), objHeading = 90.0, objCoords = vector3(471.3, -1010.1, 26.4)},
				{objHash = GetHashKey('gabz_mrpd_door_02'), objHeading = 270.0, objCoords = vector3(471.3, -1007.7, 26.4)}
			}
		},
	
		-- Cell Door 2
		{
			objHash = GetHashKey('gabz_mrpd_cells_door'),
			objHeading = 0.0,
			objCoords = vector3(477.9, -1012.1, 26.4),
			textCoords = vector3(477.9, -1012.1, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25
		},
	
		-- Cell Door 3
		{
			textCoords = vector3(480.9, -1012.1, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25,
			doors = {
				{objHash = GetHashKey('gabz_mrpd_cells_door'), objHeading = 0.0, objCoords = vector3(480.9, -1012.1, 26.4)}
			}
		},
	
		-- Cell Door 4
		{
			objHash = GetHashKey('gabz_mrpd_cells_door'),
			objHeading = 0.0,
			objCoords = vector3(483.9, -1012.1, 26.4),
			textCoords = vector3(483.9, -1012.1, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25
		},
	
		-- Cell Door 5
		{
			objHash = GetHashKey('gabz_mrpd_cells_door'),
			objHeading = 0.0,
			objCoords = vector3(486.9, -1012.1, 26.4),
			textCoords = vector3(486.9, -1012.1, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25
		},
	
		-- Cell Door 6
		{
			objHash = GetHashKey('gabz_mrpd_cells_door'),
			objHeading = 180.0,
			objCoords = vector3(484.1, -1007.7, 26.4),
			textCoords = vector3(484.1, -1007.7, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25
		},
	
		-- Cell Door 7
		{
			textCoords = vector3(480.85, -997.9, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.5,
			doors = {
				{objHash = GetHashKey('gabz_mrpd_door_02'), objHeading = 179.0, objCoords = vector3(482.0, -997.9, 26.4)},
				{objHash = GetHashKey('gabz_mrpd_door_02'), objHeading = 359.9, objCoords = vector3(479.6, -997.9, 26.4)}
			}
		},
	
		-- Evidence
		{
			objHash = GetHashKey('gabz_mrpd_door_03'),
			objHeading = 134.9,
			objCoords = vector3(475.8, -990.4, 26.4),
			textCoords = vector3(475.8, -990.4, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25
		},
	
		-- Interrogation 1
		{
			textCoords = vector3(482.6, -987.5, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25,
			doors = {
				{objHash = GetHashKey('gabz_mrpd_door_04'), objHeading = 270.1, objCoords  = vector3(482.6, -987.5, 26.4)}
			}
		},
	
		-- Interrogation 1
		{
			textCoords = vector3(482.6, -995.7, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25,
			doors = {
				{objHash = GetHashKey('gabz_mrpd_door_04'), objHeading = 270.1, objCoords  = vector3(482.6, -995.7, 26.4)}
			}
		},
	
		-- Armory Door 1
		{
			objHash = GetHashKey('gabz_mrpd_door_03'),
			objHeading = 89.7,
			objCoords = vector3(479.7, -999.6, 30.7),
			textCoords = vector3(479.7, -999.6, 30.7),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25
		},
	
		-- Armory Door 2
		{
			objHash = GetHashKey('gabz_mrpd_door_03'),
			objHeading = 180.9,
			objCoords = vector3(487.4, -1000.1, 30.7),
			textCoords = vector3(487.4, -1000.1, 30.7),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 1.25
		},
	
		-- Side Entrance
		{
			textCoords = vector3(441.9, -998.7, 30.8),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 2.5,
			doors = {
				{objHash = GetHashKey('gabz_mrpd_reception_entrancedoor'), objHeading = 1.8, objCoords = vector3(440.7, -998.7, 30.8)},
				{objHash = GetHashKey('gabz_mrpd_reception_entrancedoor'), objHeading = 178.0, objCoords = vector3(443.0, -998.7, 30.8)}
			}
		},
	
		-- Back Entrance
		{
			textCoords = vector3(468.6, -1014.4, 26.4),
			authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
			locked = true,
			maxDistance = 2.5,
			doors = {
				{objHash = GetHashKey('gabz_mrpd_door_03'), objHeading = 179.7, objCoords = vector3(469.7, -1014.4, 26.4)},
				{objHash = GetHashKey('gabz_mrpd_door_03'), objHeading = 359.9, objCoords = vector3(467.3, -1014.4, 26.4)}
			}
		},
	
	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objHash = GetHashKey('v_ilev_shrfdoor'),
		objHeading = 30.0,
		objCoords = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
				authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
		locked = false,
		maxDistance = 1.25
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
				authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
		locked = false,
		maxDistance = 2.5,
		doors = {
			{objHash = GetHashKey('v_ilev_shrf2door'), objHeading = 315.0, objCoords  = vector3(-443.1, 6015.6, 31.7)},
			{objHash = GetHashKey('v_ilev_shrf2door'), objHeading = 135.0, objCoords  = vector3(-443.9, 6016.6, 31.7)}
		}
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objHash = GetHashKey('prop_gate_prison_01'),
		objCoords = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
				authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
		locked = true,
		maxDistance = 12,
		size = 2
	},

	{
		objHash = GetHashKey('prop_gate_prison_01'),
		objCoords = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
				authorizedRoles = {'SAST', 'LSPD', 'BCSO', 'Staff'}, -- Dept names
		locked = true,
		maxDistance = 12,
		size = 2
	},

}