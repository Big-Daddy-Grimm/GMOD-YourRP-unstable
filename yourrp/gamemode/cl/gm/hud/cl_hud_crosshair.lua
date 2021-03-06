--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _hl2Weapons = {}
table.insert( _hl2Weapons, "weapon_357" )
table.insert( _hl2Weapons, "weapon_alyxgun" )
table.insert( _hl2Weapons, "weapon_annabelle" )
table.insert( _hl2Weapons, "weapon_ar2" )
table.insert( _hl2Weapons, "weapon_brickbat" )
table.insert( _hl2Weapons, "weapon_bugbait" )
table.insert( _hl2Weapons, "weapon_crossbow" )
table.insert( _hl2Weapons, "weapon_crowbar" )
table.insert( _hl2Weapons, "weapon_frag" )
table.insert( _hl2Weapons, "weapon_physcannon" )
table.insert( _hl2Weapons, "weapon_pistol" )
table.insert( _hl2Weapons, "weapon_rpg" )
table.insert( _hl2Weapons, "weapon_shotgun" )
table.insert( _hl2Weapons, "weapon_smg1" )
table.insert( _hl2Weapons, "weapon_striderbuster" )
table.insert( _hl2Weapons, "weapon_stunstick" )
table.insert( _hl2Weapons, "weapon_slam" )

function isHl2Weapon( weapon )
  if table.HasValue( _hl2Weapons, weapon:GetClass() ) then
    return true
  end
  return false
end

local alphaFade = 1
local reloading = 0
local aimdownsights = 0
function HudCrosshair()
  local ply = LocalPlayer()
  if ply:Alive() and !ply:InVehicle() then
    if !contextMenuOpen then
      local weapon = ply:GetActiveWeapon()
      if weapon != NULL then
        if weapon.DrawCrosshair or isHl2Weapon( weapon ) then
          local nextPrimary = weapon:GetNextPrimaryFire()

      		if nextPrimary <= CurTime()+0.1 and ply:KeyDown( IN_ATTACK ) then
      			ch_attack1 = ch_attack1 + 2
      		else
      			ch_attack1 = ch_attack1 - 1
      		end
      		if ch_attack1 < 0 then
      			ch_attack1 = 0
      		elseif ch_attack1 > 6 then
      			ch_attack1 = 6
      		end

          if ply:KeyDown( IN_RELOAD ) and aimdownsights == 0 then
            alphaFade = 0
            aimdownsights = 1
            timer.Simple( weapon:GetNextPrimaryFire() - CurTime(), function()
              aimdownsights = 0
            end)
          end
          if ply:KeyDown( IN_ATTACK2 ) and reloading == 0 then
            alphaFade = 0
            reloading = 1
            timer.Simple( weapon:GetNextPrimaryFire() - CurTime(), function()
              reloading = 0
            end)
          end
          if ply:KeyDown( IN_SPEED ) and ply:KeyDown( IN_FORWARD ) and reloading == 0 then
            alphaFade = alphaFade - 0.05
            if alphaFade < 0 then
              alphaFade = 0
            end
          elseif reloading == 0 then
            alphaFade = alphaFade + 0.1
            if alphaFade > 1 then
              alphaFade = 1
            end
          end

          if is_hud_db_loaded() then
            if ply:Alive() then
              if tonumber( HudV("cht") ) == 1 then

                if weapon:GetNetworkedBool( "Ironsights" ) then
                  alphaFade = 0
                  return
                end
                local p = ply:GetEyeTrace().HitPos:ToScreen()
              	local x,y = p.x, p.y

              	local gap = (HudV("chg")/2)
                if ch_attack1 >= 1 then
                  gap = gap * ch_attack1
                end
              	local length = gap + HudV("chl")

                local w = HudV("chl")
                local h = HudV("chh")

                surface.SetDrawColor( HudV("colchbrr"), HudV("colchbrg"), HudV("colchbrb"), HudV("colchbra") * alphaFade )

                local br = HudV("chbr")
                surface.DrawRect( x-w-gap-br, y-h/2-br, w+2*br, h+2*br )
                surface.DrawRect( x+gap-br, y-h/2-br, w+2*br, h+2*br )

                surface.DrawRect( x-h/2-br, y-w-gap-br, h+2*br, w+2*br )
                surface.DrawRect( x-h/2-br, y+gap-br, h+2*br, w+2*br )

                surface.SetDrawColor( HudV("colchcr"), HudV("colchcg"), HudV("colchcb"), HudV("colchca") * alphaFade )

                surface.DrawRect( x-w-gap, y-h/2, w, h )
                surface.DrawRect( x+gap, y-h/2, w, h )

                surface.DrawRect( x-h/2, y-w-gap, h, w )
                surface.DrawRect( x-h/2, y+gap, h, w )
              end
            end
          end
        end
      end
    end
  end
end
