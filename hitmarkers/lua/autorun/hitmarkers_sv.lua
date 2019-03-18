if CLIENT then return end

AddCSLuaFile( "autorun/hitmarkers_cl.lua" )
resource.AddFile( "sound/hitmarkers/hitmarker.ogg" )
resource.AddFile( "materials/hitmarkers/hitmarker.png" )

util.AddNetworkString( "hitmarker" )

hook.Add( "EntityTakeDamage", "hitmarkers", function( tar, info )

    if not tar:IsPlayer() and not tar:IsNPC() then return end
    local att = info:GetAttacker()
    if not att:IsPlayer() then return end
    if att:GetInfo( "hitmarkers_enabled" ) ~= "1" then return end

    net.Start( "hitmarker" )
        net.WriteUInt( math.max( math.min( info:GetDamage(), 65535 ), 0 ), 16 )
        if att:GetInfo( "hitmarkers_numbers" ) then
            net.WriteVector(info:GetDamagePosition() + (att:GetShootPos() - info:GetDamagePosition()):GetNormal() * 10)
        end
    net.Send( att )

end )
