if SERVER then return end

CreateConVar( "hitmarkers_enabled", "1", {
	FCVAR_ARCHIVE,
	FCVAR_USERINFO
}, "Enables hitmarkers" )
local cv_crit = CreateConVar( "hitmarkers_criticals", "0", {
	FCVAR_ARCHIVE
}, "If enabled, high damage attacks will have a different colour" )
local cv_size = CreateConVar( "hitmarkers_size", "128", {
	FCVAR_ARCHIVE
}, "The size of the hitmarker cross" )
local cv_sound = CreateConVar( "hitmarkers_sound", "1", {
	FCVAR_ARCHIVE
}, "If enabled, hitmarkers will play a sound" )
local cv_time = CreateConVar( "hitmarkers_time", "1", {
	FCVAR_ARCHIVE
}, "Sets how long hitmarkers should be visible on screen" )

local mat_hitmarker = Material( "hitmarkers/hitmarker.png" )
local snd_hitmarker = Sound( "hitmarkers/hitmarker.ogg" )
local last_time = 0
local critical = false

net.Receive( "hitmarker", function()
	if cv_sound:GetBool() then
		surface.PlaySound( snd_hitmarker )
	end
	last_time = CurTime() + cv_time:GetFloat()
	critical = net.ReadBool() and cv_crit:GetBool()
end )

hook.Add( "HUDPaint", "hitmarkers", function()
	if last_time < CurTime() then return end

	local size = math.max( cv_size:GetInt(), 0 )

	if critical then
		surface.SetDrawColor( 255, 128, 0, ( last_time - CurTime() ) * 255 )
	else
		surface.SetDrawColor( 255, 255, 255, ( last_time - CurTime() ) * 255 )
	end
	surface.SetMaterial( mat_hitmarker )
	surface.DrawTexturedRect(
		ScrW() / 2 - size / 2, ScrH() / 2 - size / 2,
		size, size )
end )

hook.Add( "PopulateToolMenu", "hitmarkers", function()
	spawnmenu.AddToolMenuOption( "Utilities", "Lixquid",
		"hitmarkers", "Hitmarkers", "", "", function( pnl )

		pnl:Clear()

		pnl:CheckBox( "Enable", "hitmarkers_enabled" )
		pnl:ControlHelp( "This must be enabled for anything " ..
			"else to function.")
		pnl:CheckBox( "Enable sound", "hitmarkers_sound" )
		pnl:CheckBox( "Enable criticals", "hitmarkers_criticals" )
		pnl:ControlHelp( "Attacks that deal a large amount of damage " ..
			"will display with a different color hitmarker if enabled.")
		pnl:NumSlider( "Hitmarker Lifetime", "hitmarkers_time",
			0.1, 5, 2 )
		pnl:NumSlider( "Hitmarker Size", "hitmarkers_size",
			16, 512, 0 )

	end )
end )
