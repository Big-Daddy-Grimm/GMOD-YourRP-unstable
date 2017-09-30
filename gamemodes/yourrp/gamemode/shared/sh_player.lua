--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:GetPlayerModel()
  if SERVER then
    local yrp_players = dbSelect( "yrp_players", "CurrentCharacter", nil )
    if worked( yrp_players ) then
      local yrp_characters = dbSelect( "yrp_characters", "playermodel", "uniqueID = " .. yrp_players[1].CurrentCharacter )
      if worked( yrp_characters ) then
        if yrp_characters[1].playermodel == "" then
          self.pm = "models/player/skeleton.mdl"
        else
          self.pm = yrp_characters[1].playermodel
        end
      end
    end
  end
  return self.pm
end

function Player:GetPlayerModelSize()
  return nil
end

function Player:GetPlyTab()
  if SERVER then
    local yrp_players = dbSelect( "yrp_players", "*", nil )
    if worked( yrp_players ) then
      self.plytab = yrp_players[1]
    end
  end
  return self.plytab
end

function Player:GetChaTab()
  if SERVER then
    local yrp_players = dbSelect( "yrp_players", "CurrentCharacter", nil )
    if worked( yrp_players ) then
      local yrp_characters = dbSelect( "yrp_characters", "*", "uniqueID = " .. yrp_players[1].CurrentCharacter )
      if worked( yrp_characters ) then
        self.chatab = yrp_characters[1]
      end
    end
  end
  return self.chatab
end

function Player:GetRolTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters ) then
      local yrp_roles = dbSelect( "yrp_roles", "*", "uniqueID = " .. yrp_characters.roleID )
      if worked( yrp_roles ) then
        self.roltab = yrp_roles[1]
      end
    end
  end
  return self.roltab
end

function Player:GetGroTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters ) then
      local yrp_groups = dbSelect( "yrp_groups", "*", "uniqueID = " .. yrp_characters.groupID )
      self.grotab = yrp_groups[1]
    end
  end
  return self.grotab
end

function Player:CharID()
  if SERVER then
    local char = self:GetChaTab()
    if worked( char ) then
      self.charid = char.uniqueID
    end
  end
  if self.charid == nil then
    self.charid = -1
  end
  return self.charid
end

function Player:UpdateMoney()
  if SERVER then
    local money = self:GetNWInt( "money" )
    if worked( money ) then
      dbUpdate( "yrp_characters", "money = " .. money, "uniqueID = " .. self:CharID() )
    end
    local moneybank = self:GetNWInt( "moneybank" )
    if worked( moneybank ) then
      dbUpdate( "yrp_characters", "moneybank = " .. moneybank, "uniqueID = " .. self:CharID() )
    end
  end
end
