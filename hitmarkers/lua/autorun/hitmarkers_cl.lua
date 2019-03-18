if SERVER then return end

CreateConVar( "hitmarkers_enabled", "1", {
    FCVAR_ARCHIVE,
    FCVAR_USERINFO
}, "Enables hitmarkers" )
local cv_crit = CreateConVar( "hitmarkers_criticals", "0", {
    FCVAR_ARCHIVE
}, "If above zero, sets the threshold at which hitmarkers will display as 'critical'" )
local cv_size = CreateConVar( "hitmarkers_size", "128", {
    FCVAR_ARCHIVE
}, "The size of the hitmarker cross" )
local cv_sound = CreateConVar( "hitmarkers_sound", "1", {
    FCVAR_ARCHIVE
}, "If enabled, hitmarkers will play a sound" )
local cv_time = CreateConVar( "hitmarkers_time", "1", {
    FCVAR_ARCHIVE
}, "Sets how long hitmarkers should be visible on screen" )
local cv_numbers = CreateConVar( "hitmarkers_numbers", "0", {
    FCVAR_ARCHIVE, FCVAR_USERINFO
}, "If enabled, damage numbers will appear above the hit point" )
local cv_numbers_time = CreateConVar( "hitmarkers_numbers_time", "2", {
    FCVAR_ARCHIVE
}, "Sets how long damage numbers will last in-game")
local cv_numbers_size = CreateConVar( "hitmarkers_numbers_size", "1", {
    FCVAR_ARCHIVE
}, "Sets how large hitnumbers will appear")

local mat_hitmarker = Material( "hitmarkers/hitmarker.png" )
local snd_hitmarker = Sound( "hitmarkers/hitmarker.ogg" )
local last_time = 0
local critical = false
local damage_positions = {}
local fonts_created = false

net.Receive( "hitmarker", function()
    local dmg = net.ReadUInt(16)
    if cv_sound:GetBool() then
        surface.PlaySound( snd_hitmarker )
    end
    last_time = CurTime() + cv_time:GetFloat()
    critical = cv_crit:GetInt() > 0 and dmg > cv_crit:GetInt()
    if cv_numbers:GetBool() then
        table.insert(damage_positions, {
            dietime = CurTime() + math.Clamp(cv_numbers_time:GetFloat(), 0.1, 60),
            text = dmg,
            pos = net.ReadVector()
        })
    end
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

hook.Add("PostDrawTranslucentRenderables", "hitmarkers", function()
    if #damage_positions == 0 then return end

    local renderSize = math.Clamp( cv_numbers_size:GetFloat(), 0.01, 10 )

    if not fonts_created then
        surface.CreateFont("lixquid.hitmarkers", {
            font = "Roboto",
            weight = 700,
            size = 100
        })
        fonts_created = true
    end

    local ang = LocalPlayer():EyeAngles()
    ang.r = 90 - ang.p
    ang.p = 0
    ang.y = (ang.y - 90) % 360

    local numberLife = math.Clamp(cv_numbers_time:GetFloat(), 0.1, 60)
    local cur = 1
    while cur <= #damage_positions do
        local d = damage_positions[cur]
        local alpha = math.Clamp(
            (d.dietime - CurTime()) / numberLife
        , 0, 1) * 255
        cam.Start3D2D(d.pos, ang, .12 * renderSize)
            surface.SetFont("lixquid.hitmarkers")
            local w, h = surface.GetTextSize(d.text)
            surface.SetTextColor(30, 30, 30, alpha)
            surface.SetTextPos(-w / 2 + 2, -h / 2 + 2)
            surface.DrawText(d.text)
            if cv_crit:GetInt() > 0 and d.text > cv_crit:GetInt() then
                surface.SetTextColor(255, 128, 0, alpha)
            else
                surface.SetTextColor(255, 255, 255, alpha)
            end
            surface.SetTextPos(-w / 2, -h / 2)
            surface.DrawText(d.text)
        cam.End3D2D()
        if d.dietime < CurTime() then
            table.remove(damage_positions, cur)
        else
            cur = cur + 1
        end
    end

end)

hook.Add( "PopulateToolMenu", "hitmarkers", function()
    spawnmenu.AddToolMenuOption( "Utilities", "Lixquid",
        "hitmarkers", "Hitmarkers", "", "", function( pnl )

        pnl:Clear()

        pnl:CheckBox( "Enable", "hitmarkers_enabled" )
        pnl:ControlHelp( "This must be enabled for anything " ..
            "else to function.")
        pnl:CheckBox( "Enable sound", "hitmarkers_sound" )
        pnl:NumSlider( "Critical Damage Threshold", "hitmarkers_criticals",
            0, 200, 0 )
        pnl:ControlHelp( "If above zero, attacks that deal above this amount" ..
            " of damage will display a different color hitmarker." )
        pnl:NumSlider( "Hitmarker Lifetime", "hitmarkers_time",
            0.1, 5, 2 )
        pnl:NumSlider( "Hitmarker Size", "hitmarkers_size",
            16, 512, 0 )
        pnl:CheckBox( "Enable Hitnumbers", "hitmarkers_numbers" )
        pnl:ControlHelp( "Hitnumbers will display floating damage numbers" ..
            " at the damage point.")
        pnl:NumSlider( "Hitnumbers Time", "hitmarkers_numbers_time",
            0.1, 60, 1 )
        pnl:NumSlider( "Hitnumbers Size", "hitmarkers_numbers_size",
            0.01, 10, 2)

    end )
end )
