--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _advertname = "NULL"
local _restartTime = 0
hook.Add( "open_server_general", "open_server_general", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )

  local _center = 800

  local sv_generalName = vgui.Create( "DTextEntry", settingsWindow.site )
  local sv_generalAdvert = vgui.Create( "DTextEntry", settingsWindow.site )
  local sv_generalHunger = createVGUI( "DCheckBox", settingsWindow.site, 30, 30, _center, 315 )
  local sv_generalThirst = createVGUI( "DCheckBox", settingsWindow.site, 30, 30, _center, 375 )
  local sv_generalStamina = createVGUI( "DCheckBox", settingsWindow.site, 30, 30, _center, 435 )
  local sv_generalBuilding = createVGUI( "DCheckBox", settingsWindow.site, 30, 30, _center, 495 )
  local sv_generalHud = createVGUI( "DCheckBox", settingsWindow.site, 30, 30, _center, 555 )
  local sv_generalInventory = createVGUI( "DCheckBox", settingsWindow.site, 30, 30, _center, 615 )
  local sv_generalClearInventoryOnDead = createVGUI( "DCheckBox", settingsWindow.site, 30, 30, _center, 675 )
  local sv_generalGraffiti = createVGUI( "DCheckBox", settingsWindow.site, 30, 30, _center, 735 )

  local sv_generalRestartTime = vgui.Create( "DNumberWang", settingsWindow.site )

  local sv_generalViewDistance = vgui.Create( "DNumberWang", settingsWindow.site )

  local oldGamemodename = ""
  function settingsWindow.site:Paint()
    --draw.RoundedBox( 0, 0, 0, settingsWindow.site:GetWide(), settingsWindow.site:GetTall(), _yrp.colors.panel )
    draw.SimpleTextOutlined( lang_string( "gamemodename" ) .. ":", "sef", ctr( _center - 10 ), ctr( 5 + 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    if oldGamemodename != sv_generalName:GetText() then
      draw.SimpleTextOutlined( "you need to update Server!", "sef", ctr( _center + 400 + 10 ), ctr( 5 + 25 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
    draw.SimpleTextOutlined( lang_string( "advertname" ) .. ":", "sef", ctr( _center - 10 ), ctr( 90 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "updatecountdown" ) .. ":", "sef", ctr( _center - 10 ), ctr( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "hunger" ) .. ":", "sef", ctr( _center - 10 ), ctr( 330 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "thirst" ) .. ":", "sef", ctr( _center - 10 ), ctr( 390 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "stamina" ) .. ":", "sef", ctr( _center - 10 ), ctr( 450 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "building" ) .. ":", "sef", ctr( _center - 10 ), ctr( 510 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "server_hud" ) .. ":", "sef", ctr( _center - 10 ), ctr( 570 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "inventory" ) .. ":", "sef", ctr( _center - 10 ), ctr( 630 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "clearinventoryondead" ) .. ":", "sef", ctr( _center - 10 ), ctr( 690 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "graffiti" ) .. ":", "sef", ctr( _center - 10 ), ctr( 750 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "thirdpersonviewdistance" ) .. ":", "sef", ctr( _center - 10 ), ctr( 810 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  sv_generalName:SetPos( ctr( _center ), ctr( 5 ) )
  sv_generalName:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalName:SetText( GAMEMODE.Name )

  net.Start("dbGetGeneral")
  net.SendToServer()

  net.Receive( "dbGetGeneral", function()
    local _yrp_general = net.ReadTable()
    GAMEMODE.Name = _yrp_general.name_gamemode or "FAILED"
    oldGamemodename = GAMEMODE.Name
    sv_generalName:SetText( GAMEMODE.Name )
    _advertname = _yrp_general.name_advert or "FAILED"
    sv_generalAdvert:SetText( tostring( _advertname ) )
    sv_generalHunger:SetChecked( tobool( _yrp_general.toggle_hunger ) )
    sv_generalThirst:SetChecked( tobool( _yrp_general.toggle_thirst ) )
    sv_generalStamina:SetChecked( tobool( _yrp_general.toggle_stamina ) )
    sv_generalBuilding:SetChecked( tobool( _yrp_general.toggle_building ) )
    sv_generalHud:SetValue( tonumber( _yrp_general.toggle_hud ) )
    sv_generalInventory:SetValue( tonumber( _yrp_general.toggle_inventory ) )
    sv_generalClearInventoryOnDead:SetValue( tonumber( _yrp_general.toggle_clearinventoryondead ) )
    sv_generalGraffiti:SetValue( tonumber( _yrp_general.toggle_graffiti ) )
    sv_generalRestartTime:SetValue( tonumber( _yrp_general.time_restart ) )
    sv_generalViewDistance:SetValue( tonumber( _yrp_general.view_distance ) )
  end)

  sv_generalAdvert:SetPos( ctr( _center ), ctr( 5 + 50 + 10 ) )
  sv_generalAdvert:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalAdvert:SetText( _advertname )
  function sv_generalAdvert:OnChange()
    net.Start( "updateAdvert" )
      net.WriteString( sv_generalAdvert:GetText() )
    net.SendToServer()
  end

  sv_generalRestartTime:SetPos( ctr( _center ), ctr( 5 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartTime:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalRestartTime:SetMin( 3 )
  sv_generalRestartTime:SetMax( 240 )
  sv_generalRestartTime:SetDecimals( 0 )
  function sv_generalRestartTime:OnValueChanged( value )
    net.Start( "updateGeneral" )
      net.WriteString( tostring( math.Round( value ) ) )
    net.SendToServer()
  end

  local sv_generalRestartServer = vgui.Create( "DButton", settingsWindow.site )
  sv_generalRestartServer:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalRestartServer:SetPos( ctr( 5 ), ctr( 5 + 50 + 10 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartServer:SetText( lang_string( "updateserver" ) )
  function sv_generalRestartServer:Paint()
    local color = Color( 255, 0, 0, 200 )
    if sv_generalRestartServer:IsHovered() then
      color = Color( 255, 255, 0, 200 )
    end
    draw.RoundedBox( ctr( 10 ), 0, 0, sv_generalRestartServer:GetWide(), sv_generalRestartServer:GetTall(), color )
  end
  function sv_generalRestartServer:DoClick()
    if sv_generalName != nil then
      net.Start( "updateServer" )
        GAMEMODE.Name = sv_generalName:GetText()
        net.WriteString( GAMEMODE.Name )
        net.WriteInt( math.Round( sv_generalRestartTime:GetValue() ), 16 )
      net.SendToServer()
    end
    settingsWindow:Close()
  end

  local sv_generalRestartServerCancel = vgui.Create( "DButton", settingsWindow.site )
  sv_generalRestartServerCancel:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalRestartServerCancel:SetPos( ctr( 5 + 400 + 10 ), ctr( 5 + 50 + 10 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartServerCancel:SetText( lang_string( "cancelupdateserver" ) )
  function sv_generalRestartServerCancel:Paint()
    local color = Color( 0, 255, 0, 200 )
    if sv_generalRestartServerCancel:IsHovered() then
      color = Color( 255, 255, 0, 200 )
    end
    draw.RoundedBox( ctr( 10 ), 0, 0, sv_generalRestartServerCancel:GetWide(), sv_generalRestartServerCancel:GetTall(), color )
  end
  function sv_generalRestartServerCancel:DoClick()
    net.Start( "cancelRestartServer" )
    net.SendToServer()
    settingsWindow:Close()
  end

  local sv_generalHardReset = vgui.Create( "DButton", settingsWindow.site )
  sv_generalHardReset:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalHardReset:SetPos( ctr( 5 ), ctr( 5 + 50 + 10 + 50 + 10 + 50 + 10 + 50 + 10 ) )
  sv_generalHardReset:SetText( lang_string( "hardresetdatabase" ) )
  function sv_generalHardReset:Paint( pw, ph )
    local color = Color( 255, 0, 0, 200 )
    if sv_generalHardReset:IsHovered() then
      color = Color( 255, 255, 0, 200 )
    end
    draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, color )
  end
  function sv_generalHardReset:DoClick()
    local _tmpFrame = createVGUI( "DFrame", nil, 630, 110, 0, 0 )
    _tmpFrame:Center()
    _tmpFrame:SetTitle( lang_string( "areyousure" ) )
    function _tmpFrame:Paint( pw, ph )
      local color = Color( 0, 0, 0, 200 )
      draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, color )
    end

    local sv_generalHardResetSure = vgui.Create( "DButton", _tmpFrame )
    sv_generalHardResetSure:SetSize( ctr( 300 ), ctr( 50 ) )
    sv_generalHardResetSure:SetPos( ctr( 10 ), ctr( 50 ) )
    sv_generalHardResetSure:SetText( lang_string( "yes" ) .. ": DELETE DATABASE" )
    function sv_generalHardResetSure:DoClick()
      net.Start( "hardresetdatabase" )
      net.SendToServer()
      _tmpFrame:Close()
    end
    function sv_generalHardResetSure:Paint( pw, ph )
      local color = Color( 255, 0, 0, 200 )
      if sv_generalHardResetSure:IsHovered() then
        color = Color( 255, 255, 0, 200 )
      end
      draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, color )
    end

    local sv_generalHardResetNot = vgui.Create( "DButton", _tmpFrame )
    sv_generalHardResetNot:SetSize( ctr( 300 ), ctr( 50 ) )
    sv_generalHardResetNot:SetPos( ctr( 10 + 300 + 10 ), ctr( 50 ) )
    sv_generalHardResetNot:SetText( lang_string( "no" ) .. ": do nothing" )
    function sv_generalHardResetNot:DoClick()
      _tmpFrame:Close()
    end
    function sv_generalHardResetNot:Paint( pw, ph )
      local color = Color( 0, 255, 0, 200 )
      if sv_generalHardResetNot:IsHovered() then
        color = Color( 255, 255, 0, 200 )
      end
      draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, color )
    end

    settingsWindow:Close()
    _tmpFrame:MakePopup()
  end

  function sv_generalHunger:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_hunger" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalThirst:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_thirst" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalStamina:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_stamina" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalBuilding:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "dbUpdateNWBool2" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalHud:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_hud" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalInventory:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_inventory" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalClearInventoryOnDead:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_clearinventoryondead" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalGraffiti:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_graffiti" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  sv_generalViewDistance:SetPos( ctr( _center ), ctr( 785 ) )
  sv_generalViewDistance:SetSize( ctr( 200 ), ctr( 50 ) )
  sv_generalViewDistance:SetMin( 0 )
  sv_generalViewDistance:SetMax( 800 )
  sv_generalViewDistance:SetDecimals( 0 )
  function sv_generalViewDistance:OnValueChanged( value )
    if tonumber( value ) > tonumber( self:GetMax() ) then
      value = tonumber( self:GetMax() )
      self:SetValue( value )
    end
    net.Start( "db_update_view_distance" )
      net.WriteInt( tostring( math.Round( value ) ), 16 )
    net.SendToServer()
  end
end)
