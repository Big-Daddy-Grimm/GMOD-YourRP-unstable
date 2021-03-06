--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_players"

sql_add_column( _db_name, "SteamID", "TEXT" )
sql_add_column( _db_name, "SteamID64", "TEXT" )
sql_add_column( _db_name, "SteamName", "TEXT" )

sql_add_column( _db_name, "CurrentCharacter", "INT" )
sql_add_column( _db_name, "Timestamp", "INT" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

g_db_reseted = false
function save_clients( string )
  printGM( "db", string.upper( "[Saving all clients]" ) )
  if !g_db_reseted then
    for k, ply in pairs( player.GetAll() ) do

      local _result = db_update( _db_name, "Timestamp = " .. os.time(), "SteamID = '" .. ply:SteamID() .. "'" )

      if ply:Alive() then
        local _char_id = ply:CharID()
        if worked( _char_id, "CharID failed @save_clients" ) then
          local _ply_pos = "position = '" .. tostring( ply:GetPos() ) .. "'"
          if worked( _ply_pos, "_ply_pos failed @save_clients" ) then
            db_update( "yrp_characters", _ply_pos, "uniqueID = " .. _char_id )
          end

          local _ply_ang = "angle = '" .. tostring( ply:EyeAngles() ) .. "'"
          if worked( _ply_ang, "_ply_ang failed @save_clients" ) then
            db_update( "yrp_characters", _ply_ang, "uniqueID = " .. _char_id )
          end

          if worked( ply:GetNWString( "money" ), "money failed @save_clients" ) and isnumber( tonumber( ply:GetNWString( "money" ) ) ) then
            local _money = "money = '" .. ply:GetNWString( "money" ) .. "'"
            local _mo_result = db_update( "yrp_characters", _money, "uniqueID = " .. _char_id )
          end

          if worked( ply:GetNWString( "moneybank" ), "moneybank failed @save_clients" ) and isnumber( tonumber( ply:GetNWString( "moneybank" ) ) ) then
            local _moneybank = "moneybank = '" .. ply:GetNWString( "moneybank" ) .. "'"
            local _mb_result = db_update( "yrp_characters", _moneybank, "uniqueID = " .. _char_id )
          end

          if worked( db_sql_str2( string.lower( game.GetMap() ) ), "getmap failed @save_clients" ) then
            local _map = "map = '" .. db_sql_str2( string.lower( game.GetMap() ) ) .. "'"
            db_update( "yrp_characters", _map, "uniqueID = " .. _char_id )
          end
        end
      end
    end
    local _all_players = player.GetCount() or 0
    printGM( "db", string.upper( "[Saved " .. tostring( _all_players ) .. " client(s)]" ) )
  else
    printGM( "db", "no saving, because db reset" )
  end
end

function set_role( ply, rid )
  --print(ply:CharID())
  if ply:HasCharacterSelected() then
    local _result = db_update( "yrp_characters", "roleID = " .. rid, "uniqueID = " .. ply:CharID() )
    local _gid = db_select( "yrp_roles", "*", "uniqueID = " .. rid )
    if _gid != nil then
      _gid = _gid[1].groupID
      local _result2 = db_update( "yrp_characters", "groupID = " .. _gid, "uniqueID = " .. ply:CharID() )
      local _result3 = db_update( "yrp_characters", "playermodelID = " .. 1, "uniqueID = " .. ply:CharID() )
    end
  end
end

function set_role_values( ply )
  if ply:HasCharacterSelected() then
    if yrp_db_loaded() then
      local rolTab = ply:GetRolTab()
      local groTab = ply:GetGroTab()
      local ChaTab = ply:GetChaTab()
      if worked( rolTab, "set_role_values rolTab" ) and worked( ChaTab, "set_role_values ChaTab" ) then
        if ChaTab.playermodelID != nil then
          local tmpID = tonumber( ChaTab.playermodelID )
          if rolTab.playermodels != nil and rolTab.playermodels != "" then
            local tmp = string.Explode( ",", rolTab.playermodels )
            if worked( tmp[tmpID], "set_role_values playermodel" ) then
              ply:SetModel( tmp[tmpID] )
            end
          end
        end
      else
        printGM( "note", "No role or/and no character -> Suicide")
        ply:KillSilent()
      end

      --[RE]--check_inv( ply, ply:CharID() )

      if worked( rolTab, "set_role_values rolTab" ) then
        ply:SetModelScale( rolTab.playermodelsize, 0 )
        ply:SetNWInt( "speedwalk", rolTab.speedwalk*rolTab.playermodelsize )
        ply:SetNWInt( "speedrun", rolTab.speedrun*rolTab.playermodelsize )
        ply:SetWalkSpeed( ply:GetNWInt( "speedwalk" ) )
        ply:SetRunSpeed( ply:GetNWInt( "speedrun" ) )
        ply:SetMaxHealth( tonumber( rolTab.hpmax ) )
        ply:SetHealth( tonumber( rolTab.hp ) )
        ply:SetNWInt( "GetHealthReg", tonumber( rolTab.hpreg ) )
        ply:SetNWInt( "GetMaxArmor", tonumber( rolTab.armax ) )
        ply:SetNWInt( "GetArmorReg", tonumber( rolTab.arreg ) )
        ply:SetArmor( tonumber( rolTab.ar ) )
        ply:SetJumpPower( tonumber( rolTab.powerjump ) * rolTab.playermodelsize )
        ply:SetNWInt( "capital", rolTab.capital )
        ply:SetNWString( "roleName", rolTab.roleID )
        ply:SetNWString( "roleUniqueID", rolTab.uniqueID )
        ply:SetNWInt( "capitaltime", rolTab.capitaltime )
        ply:SetNWBool( "yrp_voice_global", tobool(rolTab.voiceglobal) )

        --sweps
        local tmpSWEPTable = string.Explode( ",", db_out_str( rolTab.sweps ) )
        for k, swep in pairs( tmpSWEPTable ) do
          if swep != nil and swep != NULL and swep != "" then
            if !ply:HasItem( swep ) then
              ply:AddSwep( swep )
            end
          end
        end
      else
        printGM( "note", "No role selected -> Suicide")
        ply:KillSilent()
      end

      if groTab != nil then
        ply:SetNWString( "groupName", groTab.groupID )
        ply:SetNWString( "groupUniqueID", groTab.uniqueID )
        ply:SetNWString( "groupColor", groTab.color )
        ply:SetTeam( tonumber( groTab.uniqueID ) )
      else
        printGM( "note", "No group selected -> Suicide" )
        ply:KillSilent()
      end
    end
  end
end

function set_ply_pos( ply, map, pos, ang )
  timer.Simple( 0.1, function()
    if map == db_sql_str2( string.lower( game.GetMap() ) ) then
      local tmpPos = string.Split( pos, " " )
      ply:SetPos( Vector( tonumber( tmpPos[1] ), tonumber( tmpPos[2] ), tonumber( tmpPos[3] ) ) )

      local tmpAng = string.Split( ang, " " )
      ply:SetEyeAngles( Angle( tonumber( tmpAng[1] ), tonumber( tmpAng[2] ), tonumber( tmpAng[3] ) ) )
    else
      printGM( "db", "[" .. ply:SteamName() .. "] is new on this map." )
    end
  end)
end

function open_character_selection( ply )
  printGM( "db", "[" .. ply:SteamName() .. "] -> open character selection." )
  local tmpTable = db_select( "yrp_characters", "*", "SteamID = '" .. ply:SteamID() .. "'" )
  if tmpTable == nil then
    tmpTable = {}
  end
  net.Start( "openCharacterMenu" )
    net.WriteTable( tmpTable )
  net.Send( ply )
end

function add_yrp_player( ply )
  printGM( "db", "[" .. ply:SteamName() .. "] -> Add player to database." )

  ply:KillSilent()

  local _SteamID = ply:SteamID()
  local _SteamID64 = ply:SteamID64() or ""
  local _SteamName = tostring( db_sql_str( ply:SteamName() ) )
  local _ostime = os.time()

  local cols = "SteamID, "
  if !game.SinglePlayer() then
    cols = cols .. "SteamID64, "
  end
  cols = cols .. "SteamName, "
  cols = cols .. "Timestamp"

  local vals = "'" .. _SteamID .. "', "
  if !game.SinglePlayer() then
    vals = vals .. "'" .. _SteamID64 .. "', "
  end
  vals = vals .. "'" .. _SteamName .. "', "
  vals = vals .. "'" .. _ostime .. "'"

  local _insert = db_insert_into( "yrp_players", cols, vals )
  if worked( _insert, "inserting new player failed @db_players." ) then
    printGM( "db", "[" .. ply:SteamName() .. "] -> Successfully added player to database." )
  end
end

function check_yrp_player( ply )
  printGM( "db", "[" .. ply:SteamName() .. "] -> Checking if player is in database." )

  if ply:SteamID64() != nil or game.SinglePlayer() then
    local _result = db_select( "yrp_players", "*", "SteamID = '" .. ply:SteamID() .. "'")

    if _result == nil then
      add_yrp_player( ply )
    elseif _result != nil then
      printGM( "db", "[" .. ply:SteamName() .. "] is in database." )
      if #_result > 1 then
        printGM( "db", "[" .. ply:SteamName() .. "] is more then 1 time in database (" .. #_result .. ")" )
        for k, v in pairs( _result ) do
          if k > 1 then
            printGM( "db", "[" .. ply:SteamName() .. "] delete other entry." )
            db_delete_from( "yrp_players", "uniqueID = " .. v.uniqueID )
          end
        end
      end
    end
  else
    timer.Simple( 1, function()
      printGM( "db", "[" .. ply:SteamName() .. "] -> Retry check." )
      check_yrp_player( ply )
    end)
  end
end

function check_yrp_client( ply )
  printGM( "db", "[" .. ply:SteamName() .. "] -> Check client (" .. ply:SteamID() .. ")" )

  if ply:IPAddress() == "loopback" then
    printGM( "db", "[" .. ply:SteamName() .. "] -> Set UserGroup to superadmin, because owner." )
    ply:SetUserGroup( "superadmin" )
  end

  check_yrp_player( ply )

  save_clients( "check_yrp_client" )
end

util.AddNetworkString( "openCharacterMenu" )
util.AddNetworkString( "setPlayerValues" )
util.AddNetworkString( "setRoleValues" )

util.AddNetworkString( "getPlyList" )

util.AddNetworkString( "getCharakterList" )

net.Receive( "getCharakterList", function( len, ply )
  local _tmpPlyList = ply:GetChaTab()
  if _tmpPlyList != nil then
    net.Start( "getCharakterList" )
      net.WriteTable( _tmpPlyList )
    net.Send( ply )
  end
end)

net.Receive( "getPlyList", function( len, ply )
  local _tmpChaList = db_select( "yrp_characters", "*", nil )
  local _tmpRoleList = db_select( "yrp_roles", "*", nil )
  local _tmpGroupList = db_select( "yrp_groups", "*", nil )
  if _tmpChaList != nil and _tmpRoleList != nil and _tmpGroupList != nil then
    net.Start( "getPlyList" )
      net.WriteTable( _tmpChaList )
      net.WriteTable( _tmpRoleList )
      net.WriteTable( _tmpGroupList )
    net.Send( ply )
  end
end)

util.AddNetworkString( "giveRole" )

net.Receive( "giveRole", function( len, ply )
  local _tmpSteamID = net.ReadString()
  local uniqueIDRole = net.ReadInt( 16 )
  RemRolVals( ply )
  set_role( ply, uniqueIDRole )
  set_role_values( ply )
end)

function isWhitelisted( ply, id )
  local _plyAllowed = db_select( "yrp_role_whitelist", "*", "SteamID = '" .. ply:SteamID() .. "' AND roleID = " .. id )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    return true
  else
    if worked( _plyAllowed, "_plyAllowed" ) then
      return true
    else
      return false
    end
  end
end

util.AddNetworkString( "voteNo" )
net.Receive( "voteNo", function( len, ply )
  ply:SetNWString( "voteStatus", "no" )
end)

util.AddNetworkString( "voteYes" )
net.Receive( "voteYes", function( len, ply )
  ply:SetNWString( "voteStatus", "yes" )
end)

local voting = false
local votePly = nil
local voteCount = 30
function startVote( ply, table )
  if !voting then
    voting = true
    for k, v in pairs( player.GetAll() ) do
      v:SetNWString( "voteStatus", "not voted" )
      v:SetNWBool( "voting", true )
      v:SetNWString( "voteQuestion", ply:RPName() .. " want the role: " .. table[1].roleID )
    end
    votePly = ply
    voteCount = 30
    timer.Create( "voteRunning", 1, 0, function()
      for k, v in pairs( player.GetAll() ) do
        v:SetNWInt( "voteCD", voteCount )
      end
      if voteCount <= 0 then
        voting = false
        local _yes = 0
        local _no = 0
        for k, v in pairs( player.GetAll() ) do
          v:SetNWBool( "voting", false )
          if v:GetNWString( "voteStatus", "not voted" ) == "yes" then
            _yes = _yes + 1
          elseif v:GetNWString( "voteStatus", "not voted" ) == "no" then
            _no = _no + 1
          end
        end
        if _yes > _no and ( _yes + _no ) > 1 then
          --setRole( votePly:SteamID(), table[1].uniqueID )
        else
          printGM( "note", "VOTE: not enough yes" )
        end
        timer.Remove( "voteRunning" )
      end
      voteCount = voteCount - 1
    end)
  else
    printGM( "note", "a vote is currently running" )
  end
end

function canGetRole( ply, roleID )
  local tmpTableRole = db_select( "yrp_roles" , "*", "uniqueID = " .. roleID )

  if worked( tmpTableRole, "tmpTableRole" ) then
    local tmpTableGroup = db_select( "yrp_groups", "*", "uniqueID = " .. tmpTableRole[1].groupID )
    if tmpTableRole[1].uses < tmpTableRole[1].maxamount or tonumber( tmpTableRole[1].maxamount ) == -1 then
      if tmpTableRole[1].adminonly == 1 then
        printGM( "user", "Adminonly-Role" )
        if ply:IsAdmin() or ply:IsSuperAdmin() then
          -- continue
        else
          printGM( "user", "ADMIN-ONLY Role: " .. ply:SteamName() .. " is not admin or superadmin" )
          return false
        end
      elseif tonumber( tmpTableRole[1].whitelist ) == 1 then
        printGM( "user", "Whitelist-Role" )
        if tonumber( tmpTableRole[1].voteable ) == 1 then
          printGM( "user", "Voteable-Role" )
          if !isWhitelisted( ply, roleID ) then
            printGM( "user", "Start-Whitelist Vote" )
            startVote( ply, tmpTableRole )
            return false
          else
            printGM( "user", ply:SteamName() .. " already whitelisted" )
          end
        else
          printGM( "user", "No Voteable-Role" )
          if !isWhitelisted( ply, roleID ) then
            printGM( "user", ply:SteamName() .. " is not whitelisted" )
            return false
          else
            printGM( "user", ply:SteamName() .. " is whitelisted" )
          end
        end
      end
    end
    return true
  end
  return false
end

function RemRolVals( ply )
  local rolTab = ply:GetRolTab()
  if rolTab != nil then
    local _sweps = string.Explode( ",", db_out_str( rolTab.sweps ) )
    for k, v in pairs( _sweps ) do
      ply:StripWeapon( v )
    end
  end
end

net.Receive( "wantRole", function( len, ply )
  local uniqueIDRole = net.ReadInt( 16 )

  if canGetRole( ply, uniqueIDRole ) then
    --Remove Sweps from old role
    RemRolVals( ply )

    --New role
    set_role( ply, uniqueIDRole )
    set_role_values( ply )
  end
end)
